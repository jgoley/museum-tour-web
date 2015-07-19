Meteor.startup = () ->
  document.title = Session.get("DocumentTitle");
