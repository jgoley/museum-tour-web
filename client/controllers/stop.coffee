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
    value and value.match(/NULL/gi)

Template.stopContent.helpers
  isVideo: ->
    @stop.mediaType in ['2',2,'5',5]
  isAudio: ->
    @stop.mediaType in ['1','4',1,4]
  audioType: ->
    if @stop.mediaType in ['1',1]
      'audio'
    else
      'music'

  isImage: ->
    @stop.mediaType in ['3',3]
  autoplay: ->
    @stop.type is 'single'
  posterImage: ->
    console.log "Poster",@stop
    url = Blaze._globalHelpers.awsUrl()
    if @stop.posterImage and @stop.mediaType in ['2', 2]
      'http:'+url+'/'+@stop.tour+'/'+@stop.posterImage
    else if @stop.mediaType in ['1','4','5', 1, 4, 5]
      'http:'+url+'/audio-still.png'
