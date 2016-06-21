{ ReactiveVar }    = require 'meteor/reactive-var'
{ parsley,
  updateStop,
  formFiles,
  getLastStopNum }  = require '../../../helpers/edit'


require '../views/add_stop.jade'

Template.addStop.onCreated ->
  @tour         = @data.tour
  @stops        = @data.stops
  @type         = @data.type
  @siblings     = @data.siblings
  @parent       = @data.parent
  @newStopType  = new ReactiveVar 'single'
  @mediaType    = new ReactiveVar null
  @uploading    = new ReactiveVar false
  @addingStop   = @data.addingStop


Template.addStop.onRendered ->
  parsley '.add-stop'

Template.addStop.helpers
  isUploading: ->
    Template.instance().uploading.get()

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
  'change input[type=radio]': (event, instance) ->
    if $('input[name=type]:checked').val() is 'group'
      instance.newStopType.set 'group'
    else
      instance.newStopType.set 'single'

  'submit .add-stop' : (event, instance) ->
    event.preventDefault()

    form      = event.target
    siblings  = instance.siblings
    tour      = instance.tour
    stops     = instance.stops
    siblings  = instance.siblings
    type      = instance.type
    reactives =
      uploading: instance.uploading
      editing  : instance.addingStop

    props =
      files: formFiles instance.$(form)
      values: {}

    if _.isObject(tour) then tourID = tour._id else tourID = tour
    props.values.tour = tourID

    switch type
      when 'new-parent'
        props.values.stopNumber = getLastStopNum(stops.fetch())+1 or tour.baseNum+1
        props.values.type = form.type.value
      when 'new-child'
        if siblings and siblings.length
          last = siblings.length+1
        else
          last = 1
        props.values.order = last
        props.values.parent = instance.parent
        props.values.type = 'child'
      else
        props.values.stopNumber = getLastStopNum(stops.fetch())+1 or tour.baseNum+1

    updateStop(null, props, form, reactives)

  'click .cancel-add-stop' : (event, instance) ->
    instance.addingStop.set false
