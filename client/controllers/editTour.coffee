TourStops = () ->
  @Tap.Collections.TourStops
Tours = () ->
  @Tap.Collections.Tours

Template.editTour.onCreated ->
  @editTourDetails = new ReactiveVar(false)

Template.editTour.helpers
  editTourDetails: ->
    Template.instance().editTourDetails.get()
  getEditing: ->
    Template.instance().editTourDetails
  editStop: ->
    if @type is 'single'
      Session.get(@._id);
  showChildStops: ->
    Session.get(@_id)
  sortableOptions : ->
    handle: '.handle'
    onEnd: ->
      console.log "ended"
  editChildStop: (parent) ->
    Session.get("child-" + @parent + '-' + @_id)
  isGroup: ->
    @type is 'group'
  getChildStops: ->
    if @childStops
      parent = @_id
      allTourChildren = Template.instance().data.childStops.fetch()
      _.chain(allTourChildren)
        .filter((childStop) ->
          childStop.parent == parent
        ).sortBy('order')
        .value()
  addChild: ->
    Session.get('add-child-'+@_id)
  showAddStop: ->
    Session.get('add-stop')
  isOpen: ->
    if Session.get(@._id) or Session.get("child-" + @parent + '-' + @_id)
      'open'
    else
      ''
  hasMedia: (stopID) ->
    TourStops().findOne({_id: stopID}).media
  hasStops: ->
    @stops.count()
  onlyOneStop: ->
    Template.instance().data.stops.count() <= 1

Template.stopTitle.onRendered ->
  parsley('.edit-title-form')

Template.stopTitle.helpers
  editStopTitle: () ->
    Session.get('edit-title-'+@._id)

Template.editing.onCreated ->
  @mediaType = new ReactiveVar()

Template.editing.onRendered ->
  parsley('.edit-stop')
  template = Template.instance()
  template.mediaType.set(template.data.stop.mediaType)
  console.log "Media type!!!!!!!!!!!!", template.mediaType.get()

Template.editing.helpers
  notParent : (type) ->
    type is 'child' or type is 'single' or type is 'new'
  isChild : () ->
    if @stop
      @stop.type is 'child'
  progress: () ->
    Math.round this.uploader.progress() * 100
  parentStops: ->
    _.filter @stops.fetch(), (stop) ->
      stop.type is 'group'
  hasGroups: ->
    @childStops.count() > 0
  getMediaType: ->
    Template.instance().mediaType

Template.stopData.helpers
  isUpdating : () ->
    Session.get('updating'+@stop._id)

  formatFile : () ->
    @stop.media.split(' ').join('+')

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
    if stop and @value is +stop.mediaType
      'selected'

Template.mediaTypes.events
  'change .media-type-select': (e, template) ->
    if @stop and @stop.mediaType == @mediaType.get()
      change = confirm("Changing the media type will most likely require uploading a new file. Continue with change?")
      if change
        @mediaType.set(e.target.value)
    else
      @mediaType.set(e.target.value)

parsley = (formElement) ->
  $(formElement).parsley
    trigger: 'change'


uploadFile = (file, tour) ->
  new Promise (resolve, reject) ->
    S3.upload
      files:file
      unique_name: false
      path: tour
      (e,r) ->
        console.log e, r
        resolve(r)

updateStop = (stop, values, method)->
  if values.file
    uploadFile(values.file, values.values.tour).then (e,r)->
      saveStop(stop, values, method)
  else
    saveStop(stop, values, method)

saveStop = (stop, values, method) ->
  console.log stop, values
  if method is 'update'
    if stop.type is 'single'
      sessionString = stop._id
    else
      sessionString = "child-" + stop.parent + '-' + stop._id
      #update order of stops higher than edited stop
      siblings = TourStops().find($and: [
        { parent: stop.parent }
        { _id: $ne: stop._id }
        { order: $gte: +values.values.order }
      ]).fetch()
      _.each siblings, (sibling, i) ->
        TourStops().update({_id: sibling._id}, {$set: {order: sibling.order + 1}})

    TourStops().update( {_id: stop._id}, {$set:values.values}, (e,r) ->
        setTimeout (->
          Session.set('updating'+stop._id, false)
          Session.set sessionString, false
          return
        ), 2000
      )
  else
    TourStops().insert values.values, (e, id) ->
      Session.set('add-stop', false)
      Session.set('creating-stop', false)
      parent = values.values.parent
      if values.values.type is 'child'
        Session.set('add-child-'+parent, false)
        TourStops().update({_id:parent}, {$push: {childStops: id}})

getLastStopNum = (stops) ->
  _.last(stops)?.stopNumber

createStop = (values, method) ->

deleteFile = (stop)->
  path = "/#{stop.tour}/#{stop.media}"
  console.log path
  S3.delete(path, (e,s)-> console.log e,s)
  TourStops().update({_id: stop._id}, {$set:{media: ''}})

Template.editing.events

  'click .cancel': (e)->
    if @type is 'single'
      Session.set(@stop._id,false)
    else
      Session.set("child-" + @stop.parent + '-' + @stop._id, false)

  'click .delete-file' : ()->
    deleteFile(@stop)

  'submit .add-to-group': (e, template) ->
    e.preventDefault()
    parentID = e.target.parent.value
    data = template.data
    stop = data.stop
    childStops = _.filter data.childStops.fetch(), (stop) -> stop.parent is parentID
    order = _.last(childStops).order + 1

    TourStops().update {_id: stop._id}, {$set: {type: 'child', parent: parentID, order: order} }, (e,r) ->
      TourStops().update {_id: parentID}, {$addToSet: {childStops: stop._id} }

Template.addStop.onCreated ->
  @newTourType = new ReactiveVar('single')
  @mediaType = new ReactiveVar()

Template.addStop.onRendered ->
  parsley('.add-stop')

Template.addStop.helpers
  addTitle: ->
    if @type is 'new-parent'
      'Add new stop'
    else if @type is 'new-child'
      'Add new child stop'
  isCreating: ->
    Session.get('creating-stop')
  files: ->
    uploadingFiles()
  isParent: ->
    @type is 'new-parent'
  showSingleData: ->
    Template.instance().newTourType.get() is 'single'
  groupSelected: ->
    Template.instance().newTourType.get() is 'group'
  singleSelected: ->
    Template.instance().newTourType.get() is 'single'
  mediaType: ->
    Template.instance().mediaType

Template.addStop.events
  'change input[type=radio]': () ->
    if $('input[name=type]:checked').val() is 'group'
      Session.set('newStopType', 'group')
    else
      Session.set('newStopType', 'single')

  'change .new-stop-type': (e, template) ->
    console.log template.newTourType.get()
    template.newTourType.set(e.target.value)

  'submit .add-stop' : (e) ->
    e.preventDefault()
    Session.set('creating-stop', true)
    form = e.target
    if form.media?.files.length
      file = form.media?.files
    values =
      values:
        title: form.title?.value
        speaker: form.speaker?.value
        mediaType: form.mediaType?.value
        media: file?[0].name
      file: file
    #Tour ID
    values.values.type = Session.get('newStopType')
    if _.isObject(@tour) then tour = @tour._id else tour = @tour
    values.values.tour = tour

    if @type is 'new-parent'
      values.values.stopNumber = getLastStopNum(@stops.fetch())+1 or @tour.baseNum+1
      values.values.type = form.type.value

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
      values.values.stopNumber = getLastStopNum(@stops.fetch())+1 or @tour.baseNum+1
      that = @

    updateStop('', values, 'create')

  'click .cancel-add-stop' : (e) ->
    Session.set('add-child-'+@parent, false)

removeStop = (stopID, template) ->
  stopNumber = @stopNumber
  higherStops = _.filter template.data.stops.fetch(), (stop) ->
    stop.stopNumber > stopNumber
  _.each higherStops, (stop) ->
    TourStops().update {_id: stop._id}, {$set: {stopNumber: stop.stopNumber-1}}
  TourStops().remove({_id: stopID})

Template.editTour.events
  'click .delete-tour': (e) ->
    Tours().remove @tour._id, () ->
      console.log Roter
      Router.go '/admin'

  'click .show-tour-details': (e) ->
    Template.instance().editTourDetails.set(true)

  'click .edit-title-btn' : (e) ->
    if Session.get('edit-title-'+@_id)
      Session.set('edit-title-'+@_id,false)
    else
      Session.set('edit-title-'+@_id,true)

  'click .group-title': (e)->
    console.log @
    if Session.get(@_id)
      Session.set(@_id,false)
    else
      Session.set(@_id,true)

  'click .single-title': (e)->
    console.log @
    if Session.get(@_id)
      Session.set(@_id,false)
    else
      Session.set(@_id,true)

  'click .child-title': (e)->
    console.log @
    if Session.get("child-" + @parent + '-' + @_id)
      Session.set("child-" + @parent + '-' + @_id, false)
    else
      Session.set("child-" + @parent + '-' + @_id, true)

  'click .cancel-edit-title': (e) ->
    Session.set('edit-title-'+@_id,false)

  'submit .edit-title-form': (e) ->
    e.preventDefault()
    TourStops().update({_id: @_id}, {$set:{title: e.target.title.value}})
    Session.set('edit-title-'+@_id,false)

  'click .convert-group': () ->
    convertStop = confirm('Are you sure you want to convert this stop to a group?')
    if convertStop
      currentStop = @stop
      newChild = _.clone currentStop
      delete newChild._id
      delete newChild.stopNumber
      newChild.parent = currentStop._id
      newChild.type = 'child'
      newChild.order = 1
      parentQuery = "}, {$set: {type: 'group'}}"
      TourStops().insert newChild, (e, id) ->
        console.log "ID",id, e
        TourStops().update {_id: currentStop._id}, {$set: {type:'group', childStops: [id]}, $unset: {media: '', mediaType: '', speaker: ''}}, (e,r) -> console.log e,r

  'click .convert-single': () ->
    convertStop = confirm('Are you sure you want to convert this stop to a single stop?')
    if convertStop
      that = @
      lastStopNumber = _.last(Template.instance().data.stops.fetch()).stopNumber
      TourStops().update {_id: that.stop.parent}, {$pull:{childStops: that.stop._id}}, () ->
        TourStops().update {_id: that.stop._id}, {$set: {type: 'single', stopNumber: lastStopNumber+1}, $unset: {parent: '', order: ''}}, (e,r) -> console.log e,r

  'click .add-child': () ->
    Session.set('add-child-'+@_id, true)

  'submit .edit-stop': (e, instance) ->
    e.preventDefault()
    Session.set('updating'+@stop._id, true)
    form = e.target
    if form.media?.files.length
      file = form.media?.files
    values =
      values:
        speaker: form.speaker?.value
        mediaType: form.mediaType?.value
        media: file?[0].name
        order: form.order?.value
        tour: @stop?.tour
      file: file
    updateStop(@stop, values, 'update')

  'click .hide-children': (e)->
    Session.set("childStops" + @_id,false)
    parent = @
    _.chain(Template.instance().data.childStops.fetch())
      .filter((childStops) -> childStops.parent == parent._id)
      .each((child) -> Session.set("child-" + child.parent + '-' + child._id, false))

  'click .show-add-stop': ()->
    Session.set('add-stop', true)
    setTimeout (->
      $('html, body').animate({ scrollTop: $(".add-stop").offset().top - 55 }, 800)
      ), 0

  'click .cancel-add-stop': ()->
    Session.set('add-stop', false)

  'click .delete': (e)->
    if @type is 'group'
      deleteStop = confirm('Are you sure you want to delete this stop?\nAll child stops will also be deleted!')
    else
      deleteStop = confirm('Are you sure you want to delete this stop?')
    if deleteStop
      if @type is 'group'
        _.each @childStops, (childStopId) ->
          childStop = TourStops().findOne({_id:childStopId})
          console.log childStop
          if childStop.media
            deleteFile(childStop)
          removeStop(@, Template.instance())
        TourStops().remove({_id: @_id})
      else if @type is 'single'
        if @media
          deleteFile(@)
        TourStops().remove({_id: @_id})
      else
        that = @
        siblings = _.filter Template.instance().data.childStops.fetch(), (stop) ->
          stop.parent is that.parent
        higherSiblings = _.filter siblings, (stop) ->
          stop.order > that.order
        _.each higherSiblings, (stop) ->
          TourStops().update {_id: stop._id}, {$set: {order: stop.order-1}}
        TourStops().update({_id: @parent}, {$pull: {childStops: @_id}})
        console.log "delete child"
        TourStops().remove({_id: @_id})

