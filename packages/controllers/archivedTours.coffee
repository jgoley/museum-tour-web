if Meteor.isClient

  Template.archivedTours.onCreated ->
    @subscribe 'archivedTours'
    document.title = 'Archived Tours'

  Template.archivedTours.helpers
    tours: ->
      Tours.find()

    formatDate: (date) ->
      moment(date).format('MMMM D, YYYY')


if Meteor.isServer

  Meteor.publish 'archivedTours', ->
    today = moment(new Date()).format('YYYY-MM-DD')
    Tours.find
      $query:
        closeDate:
          $lte: today
      $orderby: 'openDate': -1
