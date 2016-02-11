Package.describe({
  name: 'tap:views',
  version: '0.0.1',
  summary: '',
});

Package.onUse(function(api) {
  api.versionsFrom('1.2.1');

  api.use('templating');
  api.use('mquandalle:jade');
  api.use('tap:styles');

  api.addFiles('admin.jade', 'client');
  api.addFiles('allStops.jade', 'client');
  api.addFiles('archivedTours.jade', 'client');
  api.addFiles('childStops.jade', 'client');
  api.addFiles('convert.jade', 'client');
  api.addFiles('currentTours.jade', 'client');
  api.addFiles('edit.jade', 'client');
  api.addFiles('editMedia.jade', 'client');
  api.addFiles('editStop.jade', 'client');
  api.addFiles('feedback.jade', 'client');
  api.addFiles('fileUpload.jade', 'client');
  api.addFiles('header.jade', 'client');
  api.addFiles('help.jade', 'client');
  api.addFiles('home.jade', 'client');
  api.addFiles('image.jade', 'client');
  api.addFiles('layout.jade', 'client');
  api.addFiles('loading.jade', 'client');
  api.addFiles('nav.jade', 'client');
  api.addFiles('offCanvasMenu.jade', 'client');
  api.addFiles('posterImage.jade', 'client');
  api.addFiles('signIn.jade', 'client');
  api.addFiles('stop.jade', 'client');
  api.addFiles('stopSearch.jade', 'client');
  api.addFiles('thumbnail.jade', 'client');
  api.addFiles('tour.jade', 'client');
  api.addFiles('tourDetails.jade', 'client');
  api.addFiles('upload.jade', 'client');
  api.addFiles('uploadProgress.jade', 'client');

});



