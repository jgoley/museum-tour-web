import { FlowRouter } from 'meteor/kadira:flow-router'

Template.registerHelper 'awsUrl', ->
  Meteor.settings.public.awsUrl

# From the arillo:meteor-flow-router-helpers package
Template.registerHelper 'pathFor', (path, view = {hash:{}}) ->
  throw new Error('no path defined') unless path
  # set if run on server
  view = hash: view unless view.hash
  if path.hash?.route?
    view = path
    path = view.hash.route
    delete view.hash.route
  query = if view.hash.query then FlowRouter._qs.parse(view.hash.query) else {}
  hashBang = if view.hash.hash then view.hash.hash else ''
  FlowRouter.path(path, view.hash, query) + hashBang

Template.registerHelper 'isCordova', ->
  Meteor.isCordova

Template.registerHelper 'isUploading', ->
  _.filter S3.collection.find().fetch(), (file) ->
    file.status is 'uploading'

Template.registerHelper 'hoverable', ->
  'no-hover' if Meteor.isCordova

Template.registerHelper 'isDeleting', ->
  instance = Template.instance()
  instance.deleting?.get() or instance.data.deleting?.get()

Template.registerHelper 'isNull', (value) ->
  value and value.match(/NULL/gi)
