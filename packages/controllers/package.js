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

  api.use('tap:models');
  api.use('tap:accounts');
  api.use('tap:views');

  api.use('rubaxa:sortable');
  api.use('accounts-password');
  api.use('useraccounts:core');
  api.use('momentjs:moment');
  api.use('lepozepo:s3');
  api.use('amr:parsley.js');

  api.addFiles('admin.coffee', ['client', 'server']);
  api.addFiles('archivedTours.coffee', ['client', 'server']);
  api.addFiles('childStops.coffee', ['client', 'server']);
  api.addFiles('convert.coffee', ['client']);
  api.addFiles('currentTours.coffee', ['client', 'server']);
  api.addFiles('editMedia.coffee', ['client', 'server']);
  api.addFiles('editTour.coffee', ['client', 'server']);
  api.addFiles('fileUpload.coffee', ['client', 'server']);
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
  api.addFiles('upload.coffee', ['client', 'server']);
  api.addFiles('uploadProgress.coffee', ['client']);
});
