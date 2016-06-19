{ ReactiveVar }    = require 'meteor/reactive-var'
{ parsley,
  uploadFile,
  saveStop }       = require '../../../helpers/edit'
{ getLastStopNum } = require '../../../helpers/edit'


require '../views/add_stop.jade'

Template.addStop.onCreated ->
  @tour         = @data.tour
  @stops        = @data.stops
  @type         = @data.type
  @siblings     = @data.siblings
  @parent       = @data.parent
  @newStopType  = new ReactiveVar 'single'
  @mediaType    = new ReactiveVar null
  @creatingStop = new ReactiveVar false
  @addingStop   = @data.addingStop


Template.addStop.onRendered ->
  parsley '.add-stop'

Template.addStop.helpers
  isCreating: ->
    Template.instance().creatingStop.get()

  isParent: ->
    @type is 'new-parent'

  showSingleData: ->
    Template.instance().newStopType.get() is 'single'

  groupSelected: ->
    Template.instance().newStopType.get() is 'group'

  singleSelected: ->
    Template.instance().newStopType.get() is 'single'

  mediaType: ->
    Template.instance().mediaType

Template.addStop.events
  'change input[type=radio]': (event, template) ->
    if $('input[name=type]:checked').val() is 'group'
      template.newStopType.set 'group'
    else
      template.newStopType.set 'single'

  'submit .add-stop' : (event, instance) ->
    event.preventDefault()

    creatingStop = instance.creatingStop
    form         = event.target
    tour         = instance.tour
    stops        = instance.stops
    type         = instance.type
    siblings     = instance.siblings

    creatingStop.set true

    files = []
    _.each $(form).find("[type='file']"), (file) ->
      if file.files[0] then files.push file.files[0]
    props =
      values:
        title: form.title?.value
        speaker: form.speaker?.value
        mediaType: +form.mediaType?.value
      files: files

    if files.length
      if form.media?.files[0]
        props.values.media = form.media.files[0].name.split(" ").join "+"
      if form.mediaType?.value is 2 and form.posterImage?.files[0]
        props.values.posterImage = form.posterImage.files[0].name.split(" ").join("+")

    #Tour ID
    props.values.type = instance.newStopType.get()
    if _.isObject(tour) then _tour = tour._id else _tour = tour
    props.values.tour = _tour

    if type is 'new-parent'
      props.values.stopNumber = getLastStopNum(stops.fetch())+1 or tour.baseNum+1
      props.values.type = form.type.value

    else if type is 'new-child'
      if siblings and siblings.length
        last = siblings.length+1
      else
        last = 1
      props.values.order = last
      props.values.parent = instance.parent
      props.values.type = 'child'

    else
      props.values.stopNumber = getLastStopNum(stops.fetch())+1 or tour.baseNum+1

    reactives =
      creatingStop: creatingStop
      addingStop  : instance.addingStop

    console.log props, reactives

    files = props.files
    if files.length
      uploadFile(files, tour._id)
        .then ->
          creatingStop.set false
          console.log 'Uploading'
          saveStop null, props, reactives

  'click .cancel-add-stop' : (event, instance) ->
    instance.addingStop.set false
