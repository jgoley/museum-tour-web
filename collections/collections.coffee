# @Tap = @Tap || {}
# @Tap.Collections = {}

# Tours = new Mongo.Collection 'tours'
# TourStops = new Mongo.Collection 'tourStops'

# @Tap.Collections.Tours = Tours
# @Tap.Collections.TourStops = TourStops

# # Sortable.collections = ['tourStops']
# # today = moment(new Date()).format('YYYY-MM-DD')
# if Meteor.isServer
#   # Meteor.publish 'tours', ->
#   #   Tours.find()

#   # # Meteor.publish 'allStops', ->
#   #   TourStops.find()

# # Tours.allow
# #   insert: (userId, doc) ->
# #     Meteor.user()
# #   update: (userId, doc, fields, modifier) ->
# #     Meteor.user()
# #   remove: (userId, doc) ->
# #     Meteor.user()

# # TourStops.allow
# #   insert: (userId, doc) ->
# #     Meteor.user()
# #   update: (userId, doc, fields, modifier) ->
# #     Meteor.user()
# #   remove: (userId, doc) ->
# #     Meteor.user()

# # # stopTypes =
# # # [
# # #   {label: 'Audio', value: 1},
# # #   {label: 'Video', value: 2},
# # #   {label: 'Picture', value: 3},
# # #   {label: 'Music', value: 4},
# # #   {label: 'Film', value: 5}
# # # ]
