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
    Template.instance().data.childStops
  nextStop: ->
    Template.instance().nextStop
  prevStop: ->
    Template.instance().prevStop
  isNull: (value) ->
    console.log value
    console.log value and value.match(/NULL/gi)
    value and value.match(/NULL/gi)

Template.stopContent.helpers
  isVideo: ->
    videos = ['1','2','4','5',1,2,4,5]
    @stop.mediaType in videos
  isImage: ->
    @stop.mediaType is '3' or stop.mediaType is 3
  autoplay: ->
    @stop.type is 'single'
  posterImage: ->
    console.log "Poster",@stop
    url = Blaze._globalHelpers.awsUrl()
    if @stop.posterImage and @stop.mediaType in ['2', 2]
      'http:'+url+'/'+@stop.tour+'/'+@stop.posterImage
    else
      'http:'+url+'/audio-still.png'
