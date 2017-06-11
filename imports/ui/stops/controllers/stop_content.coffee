import '../views/stop_content.jade'

Template.stopContent.onCreated ->
  @stop = @data.stop

Template.stopContent.onRendered ->
  $('video').on 'ended', (event) ->
    event.target.webkitExitFullScreen()

Template.stopContent.helpers
  autoplay: ->
    Template.instance().stop.type is 'single'

  posterImage: ->
    stop = Template.instance().stop
    url = Meteor.settings.public.awsUrl
    if stop.posterImage and stop.mediaType in ['2', 2]
      "http:#{url}/#{stop.tour}/#{stop.posterImage}"
    else if stop.mediaType in ['1','4','5', 1, 4, 5]
      "http:#{url}/audio-still.png"

Template.stopContent.events
  'click video': (event, instance) ->
    console.log event, instance

Template.stopContent.onDestroyed ->
  $('video').off 'ended'
