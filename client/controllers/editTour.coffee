TourStops = () ->
  @Tap.Collections.TourStops
Tours = () ->
  @Tap.Collections.Tours

Template.editTour.helpers
  settings: () ->
    fields: ['stopNumber','title', 'type','mediaType' ]
  editStop: () ->
    Session.get(@._id);
  showChildStops: () ->
    Session.get("childStops" + @_id)
  sortableOptions : () ->
    onEnd: () ->
      console.log "ended"
  editChildStop: (parent) ->
    Session.get("child-" + @parent + '-' + @_id)
  isGroup: () ->
    @type is 'group'
  getChildStops: () ->
    if @childStops
      parent = @_id
      allTourChildren = Template.instance().data.childStops.fetch()
      _.chain(allTourChildren)
        .filter((childStop) ->
          childStop.parent == parent
        ).sortBy('order')
        .value()
  addChild: () ->
    Session.get('add-child-'+@_id)
  showAddStop: () ->
    Session.get('add-stop')

Template.editing.helpers
  notParent : (type) ->
    console.log type
    type is 'child' or type is 'single' or type is 'new'
  isChild : () ->
    if @stop
      @stop.type is 'child'
  progress: () ->
    Math.round this.uploader.progress() * 100

Template.stopData.helpers
  isUpdating : () ->
    Session.get('updating'+@stop._id)
  files: () ->
    S3.collection.find()
  formatFile : () ->
    @stop.media.split('+').join(' ')

Template.mediaTypes.helpers
  stopTypesForm: () ->
    [
      {label: 'Audio', value: 1},
      {label: 'Video', value: 2},
      {label: 'Picture', value: 3},
      {label: 'Music', value: 4},
      {label: 'Film', value: 5}
    ]
  selected : (stop) ->
    if stop and @value is stop.mediaType
      'selected'

Template.addStop.helpers
  showSingleData: () ->
    console.log @type, Session.get('newStopType')
    @type is 'new-child' || Session.get('newStopType') is 'single'
  isCreating: () ->
    Session.get('creating-stop')
  files: () ->
    S3.collection.find()
  isParent: () ->
    @type is 'new-parent'

uploadFile = (file, tour) ->
  new Promise (resolve, reject) ->
    S3.upload
      files:file
      unique_name: false
      path: tour
      (e,r) ->
        resolve(r)

updateStop = (stop, values, method)->
  if values.file.length
    console.log 'uploading'
    uploadFile(values.file[0], values.values.tour).then (e,r)->
      console.log e,r
      saveStop(stop, values, method)
  else
    saveStop(stop, values, method)

saveStop = (stop, values, method) ->
  if method is 'update'
    if stop.type is 'single'
      sessionString = stop._id
    else
      sessionString = "child-" + stop.parent + '-' + stop._id
    TourStops().update( {_id: stop._id}, {$set:values.values}, () ->
        setTimeout (->
          Session.set('updating'+stop._id, false)
          Session.set sessionString, false
          return
        ), 2000
      )
  else
    TourStops().insert values.values, (e, id) ->
      console.log e,id
      Session.set('add-stop', false)
      Session.set('creating-stop', false)
      parent = values.values.parent
      if values.values.type is 'child'
        Session.set('add-child-'+parent, false)
        TourStops().update({_id:parent}, {$push: {childStops: id}})

getValues = (e) ->
  inputs = $(e.target).parent().find('.form-control').get()
  values = {}
  files= []
  _.each inputs, (input)->
    if input.files and input.files.length
      file = input.files
      values['media'] = file[0].name.split(' ').join('+')
      files.push(file)
    else if input.type is 'radio' and input.checked is true
      values[input.name] = input.value
    else if input.type is 'radio'
      return
    else
      values[input.name] = input.value
  values: values
  file: files

getLastStopNum = (stops) ->
  _.last(stops).stopNumber

createStop = (values, method) ->

deleteFile = (stop)->
  path = "/#{stop.tour}/#{stop.media}"
  console.log path
  S3.delete(path, (e,s)-> console.log e,s)
  TourStops().update({_id: stop._id}, {$set:{media: ''}})

Template.editing.events
  'click .save': (e)->
      values = getValues.call(this, e)
      values.values.tour = @stop.tour
      Session.set('updating'+@stop._id, true)
      updateStop(@stop, values, 'update')
  'click .cancel': (e)->
    if ($(e.target).parent().hasClass('editing-parent'))
      Session.set(@stop._id,false)
    else
      Session.set("child-" + @stop.parent + '-' + @stop._id, false)
  'click .delete-file' : ()->
    console.log @
    deleteFile(@stop)

Template.addStop.rendered = () ->
  Session.set('newStopType', 'single')


Template.addStop.events
  'change input[type=radio]': () ->
    if $('input[name=type]:checked').val() is 'group'
      Session.set('newStopType', 'group')
    else
      Session.set('newStopType', 'single')
  'click .add-stop' : (e) ->
    console.log @
    Session.set('creating-stop', true)
    values = getValues(e)
    if _.isObject(@tour)
      tour = @tour._id
    else tour = @tour
    values.values.tour = tour
    if @type is 'new-parent'
      values.values.stopNumber = getLastStopNum(@stops.fetch())+1
    else if @type is 'new-child'
      if @siblings and @siblings.length
        last = @siblings.length+1
      else
        last = 1
      console.log last
      values.values.order = last
      values.values.parent = @parent
      values.values.type = 'child'
    else
      values.values.stopNumber = getLastStopNum(@stops.fetch())+1
      that = @
    console.log values
    updateStop('', values, 'create')
  'click .cancel-add-stop' : (e) ->
    Session.set('add-child-'+@parent, false)

Template.editTour.events
  'dblclick .parent-stops .title' : (e) ->
    console.log @
    Session.set(@_id,true)

  'dblclick .child-stops .title' : (e) ->
    Session.set("child-" + @parent + '-' + @_id, true)

  'click .show-children': (e)->
    Session.set("childStops" + @_id,true)

  'click .convert': () ->
    convertStop = confirm('Are you sure you want to convert this stop to a group?')
    if convertStop
      newChild = _.clone @
      delete newChild._id
      delete newChild.stopNumber
      newChild.parent = @_id
      newChild.type = 'child'
      newChild.order = 1
      console.log @,newChild
      parentQuery = "}, {$set: {type: 'group'}}"
      that = @
      TourStops().insert newChild, (e, id) ->
        console.log "ID",id, e
        TourStops().update {_id: that._id}, {$set: {type:'group', childStops: [id]}, $unset: {media: '', mediaType: '', speaker: ''}}, (e,r) -> console.log e,r

  'click .add-child': () ->
    Session.set('add-child-'+@_id, true)

  'click .hide-children': (e)->
    Session.set("childStops" + @_id,false)
    parent = @
    _.chain(Template.instance().data.childStops.fetch())
      .filter((childStops) -> childStops.parent == parent._id)
      .each((child) -> Session.set("child-" + child.parent + '-' + child._id, false))

  'click .show-add-stop': ()->
    Session.set('add-stop', true)

  'click .cancel-add-stop': ()->
    Session.set('add-stop', false)

  'click .delete': (e)->
    deleteStop = confirm('Are you sure you want to delete this stop?')
    if deleteStop
      if @media
        deleteFile(@)
      if @type is 'group' or @type is 'single'
        stopNumber = @stopNumber
        TourStops().remove({_id: @_id})
        higherStops = _.filter Template.instance().data.stops.fetch(), (stop) ->
          stop.stopNumber > stopNumber
        _.each higherStops, (stop) ->
          TourStops().update {_id: stop._id}, {$set: {stopNumber: stop.stopNumber-1}}
      else
        #change order
        console.log Template.instance().data.childStops.fetch()
        console.log @parent,"p"
        that = @
        siblings = _.filter Template.instance().data.childStops.fetch(), (stop) ->
          stop.parent is that.parent
        console.log siblings
        higherSiblings = _.filter siblings, (stop) ->
          stop.order > that.order
        console.log higherSiblings
        _.each higherSiblings, (stop) ->
          TourStops().update {_id: stop._id}, {$set: {order: stop.order-1}}
        TourStops().update({_id: @parent}, {$pull: {childStops: @_id}})
        console.log "delete child"
        TourStops().remove({_id: @_id})

