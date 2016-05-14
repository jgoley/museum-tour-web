Package.describe({
  name: 'tap:controllers',
  version: '0.0.1'
});

Package.onUse(function(api) {
  api.versionsFrom('1.2.1');

  api.use('ecmascript');
  api.use('underscore');
  api.use('coffeescript');
  api.use('templating');
  api.use('reactive-var');
  api.use('reactive-dict');

  api.use('tap:models');
  api.use('tap:accounts');
  api.use('tap:views');
  api.use('tap:admin');

  api.use('momentjs:moment');

  api.addFiles('archivedTours.coffee', ['client', 'server']);
  api.addFiles('childStops.coffee', ['client', 'server']);
  api.addFiles('currentTours.coffee', ['client', 'server']);
  api.addFiles('header.coffee', ['client']);
  api.addFiles('help.coffee', ['client']);
  api.addFiles('helpers.coffee', ['client']);
  api.addFiles('image.coffee', ['client', 'server']);
  api.addFiles('layout.coffee', ['client']);
  api.addFiles('offCanvasMenu.coffee', ['client']);
  api.addFiles('posterImage.coffee', ['client']);
  api.addFiles('services.coffee', ['client']);
  api.addFiles('stop.coffee', ['client', 'server']);
  api.addFiles('stopSearch.coffee', ['client']);
  api.addFiles('thumbnail.coffee', ['client']);
  api.addFiles('tour.coffee', ['client', 'server']);
  api.addFiles('tourDetails.coffee', ['client', 'server']);
});
