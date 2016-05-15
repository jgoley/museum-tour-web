Package.describe({
  name: 'tap:admin',
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

  api.use('rubaxa:sortable');
  api.use('accounts-password');
  api.use('useraccounts:core');
  api.use('momentjs:moment');
  api.use('amr:parsley.js');
  api.use('lepozepo:s3');

  api.addFiles('convert.coffee', ['client']);
  api.addFiles('edit_tour.coffee', ['client', 'server']);
  api.addFiles('edit_tours.coffee', ['client', 'server']);
  api.addFiles('editMedia.coffee', ['client', 'server']);
  api.addFiles('fileUpload.coffee', ['client', 'server']);
  api.addFiles('upload.coffee', ['client', 'server']);
  api.addFiles('uploadProgress.coffee', ['client']);
});
