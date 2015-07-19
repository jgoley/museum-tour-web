Tours = () ->
  @Tap.Collections.Tours

TourStops = () ->
  @Tap.Collections.TourStops

Template.stop.created = () ->
  document.title = Template.instance().data.stop.title
  data= Template.instance().data
  stops = data.tourStops.fetch()
  @prevStop = _.find stops, (stop)->
    stop.stopNumber is data.stop.stopNumber-1
  @nextStop = _.find stops, (stop)->
    stop.stopNumber is data.stop.stopNumber+1

Template.stop.helpers
  getChildStops: ->
    @childStops.fetch()
  nextStop: ->
    Template.instance().nextStop
  prevStop: ->
    Template.instance().prevStop
  isNull: (value) ->
    console.log value
    console.log value and value.match(/NULL/gi)
    value and value.match(/NULL/gi)

Template.stopContent.helpers
  isVideo: (stop) ->
    videos = ['1','2','4','5',1,2,4,5]
    stop.mediaType in videos
  isImage: (stop) ->
    stop.mediaType is '3' or stop.mediaType is 3
  autoplay: (stop) ->
    console.log stop.type is 'single'
    stop.type is 'single'
