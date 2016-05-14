if Meteor.isClient

  parsley = (formElement) ->
    $(formElement).parsley
      trigger: 'change'

  updateStop = (stop, values, method) ->
    if values.files.length
      Meteor.call 'uploadFile', values.files, values.values.tour, (err,res)->
        if err
          throw new Metoer.Meteor.Error err.reason
        else
          Meteor.call 'saveStop', stop, values, method, (err, res) ->
            if err
              Tap.services.showNotification(err.reaon, sessionString)
            else
              Tap.services.showNotification(err, sessionString)
              Session.set('add-stop', false)
              Session.set('creating-stop', false)
              Session.set(id,true)

    else
       Meteor.call 'saveStop', stop, values, method, (err, res) ->
        if err
          Tap.services.showNotification(err.reaon, sessionString)
        else
          Tap.services.showNotification(err, sessionString)
          Session.set('add-stop', false)
          Session.set('creating-stop', false)
          Session.set(id,true)


  getLastStopNum = (stops) ->
    _.last(stops)?.stopNumber

  createStop = (values, method) ->

  showStop = (instance, stop) ->
    editing = instance.data.activelyEditing
    editing.set not editing.get()

#################################
# EDIT TOUR
#################################

  Template.editTour.onCreated ->
    @tourID = @data.tourID
    @subscribe 'tourDetails', @tourID
    # @subscribe 'tourStops', @tourID
    @subscribe 'tourParentStops', @tourID
    @editTourDetails = new ReactiveVar false
    @creatingStop = new ReactiveVar false

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
# Parent/Single Stop
#################################

  Template.editStop.onCreated ->
    @activelyEditing = new ReactiveVar false
    @subscribe 'childStops', @data.stop._id

  Template.editStop.helpers
    editStop: ->
      Template.instance().activelyEditing.get()

    showChildStops: ->
      console.log "test", Template.instance().activelyEditing.get()
      Template.instance().activelyEditing.get()

    sortableOptions : ->
      handle: '.handle'

    editChildStop: (parent) ->
      Session.get("child-" + @stop.parent + '-' + @stop._id)

    isGroup: ->
      @stop.type is 'group'

    children: ->
      @stop.children()

    addChild: ->
      Session.get('add-child-'+@stop._id)

    showAddStop: ->
      Session.get('add-stop')

    hasMedia: (stopID) ->
      TourStops.findOne({_id: stopID}).media

    activelyEditing: ->
      Template.instance().activelyEditing


  Template.editStop.events
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
        TourStops.insert newChild, (e, id) ->
          TourStops.update {_id: currentStop._id}, {$set: {type:'group', childStops: [id]}, $unset: {media: '', mediaType: '', speaker: ''}}, (e,r) ->
            Tap.services.showNotification(e)

    'click .convert-single': () ->
      convertStop = confirm('Are you sure you want to convert this stop to a single stop?')
      if convertStop
        that = @
        lastStopNumber = _.last(Template.instance().data.stops.fetch()).stopNumber
        TourStops.update {_id: that.stop.parent}, {$pull:{childStops: that.stop._id}}, () ->
          Tap.services.showNotification(e)

    'click .add-child': () ->
      Session.set('add-child-'+@_id, true)

    'submit .edit-stop': (e, instance) ->
      # $(e.target).addClass('saved')
      e.preventDefault()
      Session.set('updating'+@stop._id, true)
      form = e.target
      mediaType = form.mediaType?.value
      files = []
      _.each $(form).find("[type='file']"), (file) ->
        if file.files[0] then files.push(file.files[0])
      values =
        values:
          speaker: form.speaker?.value
          mediaType: mediaType
          order: +form.order?.value
          tour: @stop?.tour
        files: files

      if files.length
        if form.media?.files[0]
          values.values.media = form.media.files[0]?.name.split(" ").join("+")
        if mediaType is '2' and form.posterImage?.files[0]
          values.values.posterImage = form.posterImage.files[0].name.split(" ").join("+")

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
          Meteor.call 'removeGroup', @childStops
        else if @type is 'single'
          if @media
            deleteFile(@)
          TourStops.remove({_id: @_id})
        else
          that = @
          siblings = _.filter Template.instance().data.childStops.fetch(), (stop) ->
            stop.parent is that.parent
          higherSiblings = _.filter siblings, (stop) ->
            stop.order > that.order
          _.each higherSiblings, (stop) ->
            TourStops.update {_id: stop._id}, {$set: {order: stop.order-1}}
          TourStops.update({_id: @parent}, {$pull: {childStops: @_id}})
          TourStops.remove({_id: @_id})

#################################
# Stop Title
#################################

  Template.stopTitle.onCreated ->
    @editingTitle = new ReactiveVar false

  Template.stopTitle.onRendered ->
    parsley('.edit-title-form')

  Template.stopTitle.helpers
    editingTitle: ->
      Template.instance().editingTitle.get()

  Template.stopTitle.events
    'click .edit-title-btn' : (event, instance) ->
      editing = instance.editingTitle
      prop = "title-#{@stop._id}"
      if editing.get prop then value = 0 else value = 1
      editing.set prop, value

    'click .title': (event, instance)->
      editing = instance.data.activelyEditing
      console.log event, instance, editing.get()
      editing.set not editing.get()
      # showStop instance, @stop

    # 'click .single-title': (event, instance)->
    #   showStop instance, @stop

    'click .cancel-edit-title': (event, instance) ->
      instance.editingTitle.set false

    'submit .edit-title-form': (event, instance) ->
      event.preventDefault()
      stop = @stop
      Meteor.call 'updateTitle', stop, event.target.title.value, (err, res) ->
        instance.editingTitle.set false

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
        Tap.services.showNotification(e)

#################################
# STOP DATA
#################################

  Template.stopData.helpers
    isUpdating : () ->
      Session.get('updating'+@stop._id)

    formatFile : () ->
      @stop.media.split(' ').join('+')

#################################
# MEDIATYPES
#################################

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



Meteor.methods
  # uploadFile: (files, tour) ->
  #   new Promise (resolve, reject) ->
  #     S3.upload
  #       files:files
  #       unique_name: false
  #       path: tour
  #       (e,r) ->
  #         console.log e, r
  #         resolve(r)

  saveStop: (stop, values, method) ->
    if method is 'update'
      if stop.type is 'single'
        sessionString = stop._id
      else
        sessionString = "child-" + stop.parent + '-' + stop._id
        #update ord of stops higher than edited stop
          # if stop.order != values.values.order
          #   siblings = TourStops().find({$and: [
          #     { parent: stop.parent }
          #     { _id: $ne: stop._id }
          #     { order: $gte: +values.values.order }
          #   ]}).fetch()
          #   _.each siblings, (sibling, i) ->
          #     TourStops().update {_id: sibling._id}, {$set: {order: sibling.order + 1}}, (e,r) ->

      stop.set values.values
      TourStops.update {_id: stop._id}, {$set:values.values}, (e,r) ->

          # setTimeout (->
            #   Session.set('updating'+stop._id, false)
            #
            #   return
            # ), 2000
    else
      stop = new Stop()
      stop.set values.values
      stop.save ->

      # TourSto().insert values.values, (e, id) ->
        #   Session.set('add-stop', false)
        #   Session.set('creating-stop', false)
        #   parent = values.values.parent
        #   Session.set(id,true)
        #   if values.values.type is 'child'
        #     Session.set('add-child-'+parent, false)

  deleteFile: (stop)->
    path = "#{stop.tour}/#{stop.media}"
    S3.delete path, (e,s)-> console.log e,s
    stop.set media: ''
    stop.save()
    # TourSto().update({_id: stop._id}, {$set:{media: ''}})

  deleteFolder: (tourID) ->
    path = "#{tourID}"
    S3.delete path, (e,s)-> console.log e,s

  removeGroup: (childStops) ->
    _.each childStops, (childStopId) ->
      childStop TourStops().findOne({_id:childStopId})
      if childStop.media
        deleteFile(childStop)
      removeStop(@id, Template.instance())
    TourStops.remove @_id

  removeStop: (stopID, template) ->
    stopNumber = @stopNumber
    higherStops = _.filter template.data.stops.fetch(), (stop) ->
      stop.stopNumber > stopNumber
    _.each higherStops, (stop) ->
      TourStops.update {_id: stop._id}, {$set: {stopNumber: stop.stopNumber-1}}
    TourStops.remove({_id: stopID})

  updateTitle: (stop, title) ->
    stop.set title: title
    stop.save()

if Meteor.isServer
  Meteor.publish 'tourParentStops', (tourID) ->
    TourStops.find
      $and: [
        {tour: tourID}
        {$or:
          [
            {type: 'group'},
            {type: 'single'}
          ]
        }
      ]
      {$sort: {order: 1}}
