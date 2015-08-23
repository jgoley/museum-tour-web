Template.archivedTours.onCreated ->
  document.title = 'Archived Tours'

Template.archivedTours.helpers
  formatDate: (date) ->
    moment(date).format('MMMM D, YYYY')
