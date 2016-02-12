Package.describe({
  name: 'tap:styles',
  version: '0.0.1',
  summary: ''
});

Package.onUse(function(api) {
  api.versionsFrom('1.2.1');

  api.use('twbs:bootstrap-noglyph');
  api.use('useraccounts:bootstrap');
  api.use('mquandalle:stylus');
  api.use('fortawesome:fontawesome');

  api.addAssets('icons/icons.ttf', 'client')
  api.addAssets('icons/icons.svg', 'client')
  api.addAssets('images/title.svg', 'client')

  api.addFiles('variables.import.styl', 'client');
  api.addFiles('fonts.import.styl', 'client');
  api.addFiles('extends.import.styl', 'client');
  api.addFiles('globals.import.styl', 'client');
  api.addFiles('mixins.import.styl', 'client');

  api.addFiles('accounts.import.styl', 'client');
  api.addFiles('admin.import.styl', 'client');
  api.addFiles('animate.import.styl', 'client');
  api.addFiles('editMedia.import.styl', 'client');
  api.addFiles('fileUpload.import.styl', 'client');
  api.addFiles('forms.import.styl', 'client');
  api.addFiles('header.import.styl', 'client');
  api.addFiles('loading.import.styl', 'client');
  api.addFiles('menu.import.styl', 'client');
  api.addFiles('stop.import.styl', 'client');
  api.addFiles('tour.import.styl', 'client');
  api.addFiles('tour_edit.import.styl', 'client');
  api.addFiles('tours.import.styl', 'client');

  api.addFiles('main.styl', 'client');
});
