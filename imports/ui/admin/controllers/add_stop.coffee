import { ReactiveVar } from 'meteor/reactive-var'
import { parsley,
         updateStop,
         getLastStopNum } from '../../../helpers/edit'
import { formFiles } from '../../../helpers/files'
import { showNotification } from '../../../helpers/notifications'

import '../views/add_stop.jade'

Template.addStop.onCreated ->
  @newStopType  = new ReactiveVar 'single'
  @mediaType    = new ReactiveVar '1'
  @addingStop   = @data.addingStop
  @editingStop  = @data.editingStop

Template.addStop.onRendered ->
  @autorun =>
    if @addingStop?.get()
      parsley '.add-stop'

Template.addStop.helpers
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

  showCancel: ->
    @siblings?.count() or Template.instance().data.stops?.count()

Template.addStop.events
  'change input[type=radio]': (event, instance) ->
    if $('input[name=type]:checked').val() is 'group'
      instance.newStopType.set 'group'
    else
      instance.newStopType.set 'single'

  'submit .add-stop' : (event, instance) ->
    event.preventDefault()

    data      = instance.data
    form      = event.target
    tour      = data.tour
    stops     = data.stops?.fetch()
    type      = data.type
    siblings  = data.siblings?.fetch()
    type      = data.type

    props =
      files: formFiles instance.$(form)
      values: {}

    props.values.tour = if _.isObject(tour) then tour._id else tour

    switch type
      when 'new-parent'
        props.values.stopNumber = getLastStopNum(stops)+1 or tour.baseNum+1
        props.values.type = form.type.value
      when 'new-child'
        if siblings and siblings.length
          last = siblings.length + 1
        else
          last = 1
        props.values.order = last
        props.values.parent = instance.data.parent
        props.values.type = 'child'
      else
        props.values.stopNumber = getLastStopNum(stops)+1 or tour.baseNum+1

    updateStop(null, props, form)
      .then ->
        instance.addingStop.set false
        showNotification()
      .catch (error) ->
        showNotification error

  'click .cancel-add-stop' : (event, instance) ->
    if @stop and not @stop.children().count()
      Session.set 'editingAStop', false
      instance.editingStop.set false
    instance.addingStop.set false
