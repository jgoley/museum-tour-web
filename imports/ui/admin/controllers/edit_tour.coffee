{ Meteor }           = require 'meteor/meteor'
{ Template }         = require 'meteor/templating'
{ Session }          = require 'meteor/session'
{ ReactiveVar }      = require 'meteor/reactive-var'
{ $ }                = require 'meteor/jquery'
parsley              = require 'parsleyjs'

{ showNotification } = require '../../../helpers/notifications'
{ go }               = require '../../../helpers/route_helpers'
{ Tours }            = require '../../../api/tours/index'
{ TourStops }        = require '../../../api/tour_stops/index'
{ updateStop,
  showStop,
  getLastStopNum }   = require '../../../helpers/edit'

require '../../../ui/components/upload_progress/upload_progress.coffee'
require '../../../ui/components/stop_title/stop_title.coffee'
require '../views/edit_tour.jade'

parsley = (formElement) ->
  $(formElement).parsley
    trigger: 'change'

#################################
# EDIT TOUR
#################################

Template.editTour.onCreated ->
  console.log @data
  @editTourDetails = new ReactiveVar false
  @creatingStop = new ReactiveVar false
  @tourID = @data?.tourID
  if @tourID
    @subscribe 'tourDetails', @tourID
    # @subscribe 'tourStops', @tourID
    @subscribe 'tourParentStops', @tourID

Template.editTour.helpers
  tour: ->
    Tours.findOne Template.instance().tourID
  stops: ->
    TourStops.find
      $and: [
        {type: {$ne: 'child'}}
        {tour: Template.instance().tourID}
      ]
      {sort: stopNumber: 1}

  onlyOneStop: ->
    TourStops.findOne()

  editTourDetails: ->
    Template.instance().editTourDetails.get()

  getEditing: ->
    Template.instance().editTourDetails

Template.editTour.events
  'click .delete-tour': (e, template) ->
    deleteTour = confirm("Delete tour? All stops will be deleted")
    template.data.stops.forEach (stop) ->
      deleteFile(stop)
      TourStops.remove stop._id
    deleteFolder(@tour._id)
    Tours.remove @tour._id, () ->
      go '/admin'

  'click .show-tour-details': (e) ->
    Template.instance().editTourDetails.set(true)

#################################
# Child Stop
#################################

Template.childStop.onCreated ->
  @edit = ReactiveVar false

Template.childStop.helpers
  parent: ->
    TourStops.findOne Template.instance().data.child.parent
  edit: ->
    Template.instance().edit.get()

Template.childStop.events
  'click .child-title': (event, instance) ->
    instance.edit.set not instance.edit.get()


#################################
# EDITING
#################################

Template.editing.onCreated ->
  @mediaType = new ReactiveVar()

Template.editing.onRendered ->
  parsley('.edit-stop')
  template = Template.instance()
  template.mediaType.set(template.data.stop.mediaType)

Template.editing.helpers
  parent: ->
    @stop.type is 'parent' or @stop.type is 'group'
  isChild: () ->
    @stop?.type is 'child'
  progress: () ->
    Math.round this.uploader.progress() * 100
  parentStops: ->
    TourStops.find {type: 'group'}, {sort: {title: 1}}
  getMediaType: ->
    Template.instance().mediaType

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
    order = _.last(_.sortBy(childStops, 'order')).order + 1
    TourStops.update {_id: stop._id}, {$set: {type: 'child', parent: parentID, order: order} }, (e,r) ->
      TourStops.update {_id: parentID}, {$addToSet: {childStops: stop._id} }
      showNotification(e)

#################################
# STOP DATA
#################################

Template.stopData.helpers
  isUpdating : () ->
    Session.get('updating'+@stop._id)

  formatFile : () ->
    @stop.media.split(' ').join('+')

#################################
# ADD STOP
#################################

Template.addStop.onCreated ->
  @newStopType = new ReactiveVar('single')
  # @newStopType = new ReactiveVar()
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
    Template.instance.creatingStop.get()
  files: ->
    uploadingFiles()
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
  'change input[type=radio]': (e, template) ->
    if $('input[name=type]:checked').val() is 'group'
      template.newStopType.set('group')
    else
      template.newStopType.set('single')

  'submit .add-stop' : (e) ->
    e.preventDefault()
    Template.instance.creatingStop.set(true)
    form = e.target
    files = []
    _.each $(form).find("[type='file']"), (file) ->
      if file.files[0] then files.push(file.files[0])
    values =
      values:
        title: form.title?.value
        speaker: form.speaker?.value
        mediaType: form.mediaType?.value
      files: files

    if files.length
      if form.media?.files[0]
        values.values.media = form.media.files[0].name.split(" ").join("+")
      if form.mediaType?.value is '2' and form.posterImage?.files[0]
        values.values.posterImage = form.posterImage.files[0].name.split(" ").join("+")

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
      values.values.order = last
      values.values.parent = @parent
      values.values.type = 'child'

    else
      values.values.stopNumber = getLastStopNum(@stops.fetch())+1 or @tour.baseNum+1
      that = @

    updateStop('', values, 'create')

  'click .cancel-add-stop' : (e) ->
    Session.set('add-child-'+@parent, false)
