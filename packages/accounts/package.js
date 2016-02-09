Package.describe({
  name: 'tap:accounts',
  version: '0.0.1',
  summary: 'Accounts',
});

Package.onUse(function(api) {
  api.versionsFrom('1.2.1');

  api.use('accounts-ui');
  api.use('accounts-password');
  api.use('useraccounts:core');

  api.addFiles('accounts.coffee','client');
});
