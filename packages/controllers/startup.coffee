Meteor.startup = () ->
  document.title = Session.get("DocumentTitle");
  Session.set 'offCanvas', false
