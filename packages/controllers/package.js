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

  api.use('tap:accounts');
  api.use('tap:views');

  api.use('rubaxa:sortable');
  api.use('accounts-password');
  api.use('useraccounts:core');
  api.use('momentjs:moment');
  api.use('lepozepo:s3');
  api.use('amr:parsley.js');

  api.addFiles('admin.coffee');
  api.addFiles('archivedTours.coffee');
  api.addFiles('childStops.coffee');
  api.addFiles('convert.coffee');
  api.addFiles('currentTours.coffee');
  api.addFiles('editMedia.coffee');
  api.addFiles('editTour.coffee');
  api.addFiles('fileUpload.coffee');
  api.addFiles('header.coffee');
  api.addFiles('help.coffee');
  api.addFiles('helpers.coffee');
  api.addFiles('image.coffee');
  api.addFiles('layout.coffee');
  api.addFiles('offCanvasMenu.coffee');
  api.addFiles('package.js');
  api.addFiles('posterImage.coffee');
  api.addFiles('services.coffee');
  api.addFiles('startup.coffee');
  api.addFiles('stop.coffee');
  api.addFiles('stopSearch.coffee');
  api.addFiles('thumbnail.coffee');
  api.addFiles('tour.coffee');
  api.addFiles('tourDetails.coffee');
  api.addFiles('tours.coffee');
  api.addFiles('upload.coffee');
  api.addFiles('uploadProgress.coffee');
});

// edgee:slingshot

