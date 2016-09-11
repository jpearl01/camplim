Package.describe({
  name: 'cosmos:dashboard-entry',
  version: '0.1.0',
  summary: 'Dashboard Authentication',
  git: '',
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.2');

  uses(api);

});

Package.onTest(function(api) {

  uses(api);

  api.use('tinytest', 'client');
  //api.addFiles('test/test-dashboard.js', 'client');

});

function uses(api) {

  api.use('coffeescript', ['client', 'server']);

  api.use([
    'tracker'
    , 'session'
    , 'cosmos:navigator-phasor'
  ], 'client');

  api.addFiles([
    'client/dashboard-entry.coffee'
  ], 'client');

  
  api.use([
    'cosmos:dashboard'
  ], 'server');

  api.addFiles([
    'server/dashboard.coffee'
  ], 'server');

}
