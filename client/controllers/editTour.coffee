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
  editChildStop : (parent) ->
    Session.get("child-" + @parent + '-' + @_id)
  childStops : () ->
    if @childStops
      parent = @_id
      allTourChildren = Template.instance().data.childStops.fetch()
      _.chain(allTourChildren)
        .filter((childStop) ->
          childStop.parent == parent
        ).sortBy('order')
        .value()


Template.editing.helpers
  stopTypesForm: () ->
    mediaTypes =
    [
      {label: 'Audio', value: 1},
      {label: 'Video', value: 2},
      {label: 'Picture', value: 3},
      {label: 'Music', value: 4},
      {label: 'Film', value: 5}
    ]
    if @stop.mediaType
      mediaTypes[@stop.mediaType-1]['selected'] = 'selected'
    mediaTypes
  notParent : () ->
    @stop.type is 'child' or @stop.type is 'single'
  isChild : () ->
    @stop.type is 'child'
  files: () ->
    console.log "Files", S3.collection.find()
    S3.collection.find()
  progress: () ->
    Math.round this.uploader.progress() * 100
  isUpdating : () ->
    Session.get('updating'+@stop._id)

uploadFile = (file, tour) ->
  new Promise (resolve, reject) ->
    S3.upload
      files:file
      unique_name: false
      path: tour
      (e,r) ->
        resolve(r)

updateStop = (values, stop)->
  if values.file.length
    uploadFile(values.file[0], stop.tour).then ()->
      saveStop(stop, values)
  else
    saveStop(stop, values)

saveStop = (stop, values) ->
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

getValues = (e) ->
  inputs = $(e.target).parent().find('.form-control').get()
  values = {}
  files= []
  _.each inputs, (input)->
    if input.files and input.files.length
      file = input.files
      values['media'] = file[0].name.split(' ').join('+')
      files.push(file)
    else
      values[input.name] = input.value
  values: values
  file: files

Template.editing.events
  'click .save': (e)->
      Session.set('updating'+@stop._id, true)
      updateStop(getValues.call(this, e), @stop)
  'click .cancel': (e)->
    if ($(e.target).parent().hasClass('editing-parent'))
      Session.set(@stop._id,false)
    else
      Session.set("child-" + @stop.parent + '-' + @stop._id, false)
  'click .delete-file' : ()->
    path = "/#{@stop.tour}/#{@stop.media}"
    console.log path
    S3.delete(path, (e,s)-> console.log e,s)
    TourStops().update({_id: @stop._id}, {$set:{media: ''}})


Template.editTour.events
  'dblclick .parent-stops .title' : (e) ->
    Session.set(@_id,true)

  'dblclick .child-stops .title' : (e) ->
    Session.set("child-" + @parent + '-' + @_id, true)

  'click .show-children': (e)->
    Session.set("childStops" + @_id,true)

  'click .hide-children': (e)->
    Session.set("childStops" + @_id,false)

  'click .delete': (e)->
    deleteStop = confirm('Are you sure you want to delete this stop?')
    if deleteStop
      TourStops().remove({_id: @_id})
