Package.describe({
  name: 'tap:router',
  version: '0.0.1',
  summary: ''
});

Package.onUse(function(api) {
  api.versionsFrom('1.2.1');

  api.use('coffeescript');
  api.use('templating');
  api.use('kadira:blaze-layout');
  api.use('kadira:flow-router');
  api.use('tap:controllers');
  api.use('okgrow:analytics');

  api.addFiles('router.coffee', ['client', 'server']);
  api.addFiles('helpers.coffee', ['client']);

  api.export('go', 'client');
  api.export('pathFor', 'client');

});
