{ TourStop }        = require '../../../api/tour_stops/index'
{ parsley }          = require '../../../helpers/edit'
{ showNotification } = require '../../../helpers/notifications'

require '../views/editing.jade'

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
    TourStop.find {type: 'group'}, {sort: {title: 1}}
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
    TourStop.update {_id: stop._id}, {$set: {type: 'child', parent: parentID, order: order} }, (e,r) ->
      TourStop.update {_id: parentID}, {$addToSet: {childStops: stop._id} }
      showNotification(e)
