{Meteor}      = require 'meteor/meteor'
{Template}    = require 'meteor/templating'
{ReactiveVar} = require 'meteor/reactive-var'
{TourStops}   = require '../../../api/tour_stops/index'
{go}          = require '../../../helpers/route_helpers'

require '../views/stop.jade'

Template.stop.onCreated ->
  @stopID = new ReactiveVar @data.stopID

Template.stop.onRendered ->
  @stopID.set(@data.stopID)
  instance = @
  @autorun ->
    stopID = instance.stopID.get()
    instance.subscribe 'stop', stopID
    instance.subscribe 'childStops', stopID
    instance.subscribe 'adjacentStops', stopID, instance.tourID

  @autorun ->
    instance.stop = TourStops.findOne instance.stopID.get()
    if instance.stop
      document.title = instance.stop.title

Template.stop.helpers
  stop: ->
    TourStops.findOne Template.instance().stopID.get()
  childStops: ->
    TourStops.find parent: Template.instance().stopID.get()
  nextStop: ->
    TourStops.findOne stopNumber: Template.instance().stop?.stopNumber + 1
  prevStop: ->
    TourStops.findOne stopNumber: Template.instance().stop?.stopNumber - 1
  isNull: (value) ->
    value and value.match(/NULL/gi)

jump = (event, instance, direction) ->
  event.preventDefault()
  stop = TourStops.findOne stopNumber: instance.stop.stopNumber + direction
  instance.stopID.set(stop._id)
  go 'stop', {stopID: stop._id, tourID: stop.tour}

Template.stop.events
  'click .next-stop': (event, instance) ->
    jump event, instance, 1

  'click .prev-stop': (event, instance) ->
    jump event, instance, -1

Template.stopContent.helpers
  isVideo: ->
    @stop?.mediaType in ['2',2,'5',5]
  isAudio: ->
    @stop?.mediaType in ['1','4',1,4]
  audioType: ->
    if @stop?.mediaType in ['1',1]
      'audio'
    else
      'music'
  autoplay: ->
    @stop?.type is 'single'
  posterImage: ->
    url = Meteor.settings.awsURL
    if @stop?.posterImage and @stop?.mediaType in ['2', 2]
      'http:'+url+'/'+@stop.tour+'/'+@stop.posterImage
    else if @stop?.mediaType in ['1','4','5', 1, 4, 5]
      'http:'+url+'/audio-still.png'
