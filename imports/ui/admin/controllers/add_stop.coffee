{ ReactiveVar } = require 'meteor/reactive-var'
{ parsley, updateStop } = require '../../../helpers/edit'

require '../views/add_stop.jade'

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
