Package.describe({
  name: 'tap:views',
  version: '0.0.1',
  summary: '',
});

Package.onUse(function(api) {
  api.versionsFrom('1.2.1');

  api.use('mquandalle:jade');
  api.use('tap:styles');

  api.addFiles('admin.jade');
  api.addFiles('allStops.jade');
  api.addFiles('archivedTours.jade');
  api.addFiles('childStops.jade');
  api.addFiles('convert.jade');
  api.addFiles('currentTours.jade');
  api.addFiles('edit.jade');
  api.addFiles('editMedia.jade');
  api.addFiles('editStop.jade');
  api.addFiles('feedback.jade');
  api.addFiles('fileUpload.jade');
  api.addFiles('header.jade');
  api.addFiles('help.jade');
  api.addFiles('home.jade');
  api.addFiles('image.jade');
  api.addFiles('layout.jade');
  api.addFiles('loading.jade');
  api.addFiles('nav.jade');
  api.addFiles('offCanvasMenu.jade');
  api.addFiles('package.js');
  api.addFiles('posterImage.jade');
  api.addFiles('signIn.jade');
  api.addFiles('stop.jade');
  api.addFiles('stopSearch.jade');
  api.addFiles('thumbnail.jade');
  api.addFiles('tour.jade');
  api.addFiles('tourDetails.jade');
  api.addFiles('upload.jade');
  api.addFiles('uploadProgress.jade');

});



