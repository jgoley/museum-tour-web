TourStops = ()->
  @Tap.Collections.TourStops

AutoForm.debug()

uploadFiles = (files) ->
  console.log "Files"
  S3.upload
    files:files
    unique_name: false
    path: ''
    (e,r) ->
      console.log(e,r)

editHooks = {
  onSubmit: (insertDoc, updateDoc, currentDoc) ->
    console.log "Doc",insertDoc
    files = _.map $("input[type=file]"), (file)->
      file.files[0]
    if files.length > 0
      S3.upload
        files:files
        unique_name: false
        path: ''
        (e,r) ->
          console.log(e,r)
      .insert insertDoc
      @done()
      false
    else
      console.log "adding tour", insertDoc
      TourStops().insert insertDoc
      @done()
      false

}

firstStopHooks = {
  onSubmit: (insertDoc, updateDoc, currentDoc) ->
    console.log "Doc",insertDoc
    files = _.map $("input[type=file]"), (file)->
      file.files[0]
    # if files.length > 0
      # S3.upload
      #   files:files
      #   unique_name: false
      #   path: ''
      #   (e,r) ->
          # console.log(e,r)
    TourStops().insert insertDoc, (e, id) ->
      console.log e, id

    # TourStops.update {_id: stop._id}, $push: {stops: {$each: updateDoc.$set.stops} }
    @done()
    false
    # else
    #   console.log "adding tour", insertDoc
    #   TourStops.insert insertDoc
    #   @done()
    #   false
}

addStopsHooks = {
  onSubmit: (insertDoc, updateDoc, currentDoc) ->
    files = _.map $("input[type=file]"), (file)->
      file.files[0]
    # if files.length > 0
    #   S3.upload
    #     files:files
    #     unique_name: false
    #     path: ''
    #     (e,r) ->
    #       console.log(e,r)
    #   TourStops.update insertDoc
    #   @done()
    #   false
    # else
    # console.log "adding tour", insertDoc, updateDoc, currentDoc
    console.log "INsertDoc", insertDoc, updateDoc
    TourStops().insert insertDoc, (e, id) ->
      console.log e, id
    # stop = TourStops.findOne({tourID: window.location.pathname.split('/')[2]})
    # console.log stop
      Tours.update {_id: window.location.pathname.split('/')[2]}, $push: {stops: id }

    @done()
    false

}


AutoForm.addHooks('addFirstStop', firstStopHooks);
AutoForm.addHooks('addStops', addStopsHooks);

# Template.edit.helpers
#   "files": () ->
#     S3.collection.find()

Template.editTour.helpers
  "getID": () ->
    @_id
  "currentStops" : () ->
    console.log @tour._id
    console.log TourStops().findOne({'tour': @tour._id})
    TourStops.findOne({'tour': @tour._id})