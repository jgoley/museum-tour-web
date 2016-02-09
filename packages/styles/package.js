Package.describe({
  name: 'tap:styles',
  version: '0.0.1',
  summary: '',
});

Package.onUse(function(api) {
  api.versionsFrom('1.2.1');

  api.use('mquandalle:stylus');
  api.use('fortawesome:fontawesome');
  api.use('twbs:bootstrap-noglyph');

  api.addFiles('accounts.import.styl');
  api.addFiles('admin.import.styl');
  api.addFiles('animate.import.styl');
  api.addFiles('editMedia.import.styl');
  api.addFiles('extends.import.styl');
  api.addFiles('fileUpload.import.styl');
  api.addFiles('fonts.import.styl');
  api.addFiles('forms.import.styl');
  api.addFiles('globals.import.styl');
  api.addFiles('header.import.styl');
  api.addFiles('loading.import.styl');
  api.addFiles('main.styl');
  api.addFiles('menu.import.styl');
  api.addFiles('mixins.import.styl');
  api.addFiles('package.js');
  api.addFiles('stop.import.styl');
  api.addFiles('tour.import.styl');
  api.addFiles('tour_edit.import.styl');
  api.addFiles('tours.import.styl');
  api.addFiles('variables.import.styl');

});
