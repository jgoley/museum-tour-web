Package.describe({
  name: 'museum-tour:s3',
  version: '0.0.1',
  summary: '',
  git: '',
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.3.2.4');

  api.use([
    'ecmascript',
    'coffeescript'
  ]);

  api.addFiles(['index.coffee'], 'server');

  api.export('S3');
});
