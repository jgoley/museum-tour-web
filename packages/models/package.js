Package.describe({
  name: 'tap:models',
  version: '0.0.1',
});

Package.onUse(function(api) {
  api.versionsFrom('1.2.1');

  api.use('coffeescript');
  api.use('mongo');
  api.use('jagi:astronomy');
  api.use('jagi:astronomy-validators');
  api.use('jagi:astronomy-timestamp-behavior');
  api.use('rubaxa:sortable');

  api.addFiles('tours.coffee', ['client', 'server']);
  api.addFiles('tour_stops.coffee', ['client', 'server']);
  api.addFiles('sortable.coffee', ['client', 'server']);

  api.export(['Tour', 'Tours'], ['client', 'server']);
  api.export(['TourStop', 'TourStops'], ['client', 'server']);

});

Package.onTest(function(api) {
  api.use('ecmascript');
  api.use('tinytest');
  api.use('models');
  api.addFiles('models-tests.js');
});
