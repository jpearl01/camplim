Package.describe({
  name: 'cosmos:navigator-phasor-array',
  version: '0.1.0',
  summary: 'Implement Navigator Phasor with an array',
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
  api.addFiles('test/tests.coffee', 'client');
});

function uses(api) {

  api.use([
    'coffeescript'
    , 'cosmos:navigator-phasor@0.1.0'  // ensure we have Nav
  ], 'client');

  api.addFiles([
    'client/phasor-array.coffee'
  ], 'client');

}
