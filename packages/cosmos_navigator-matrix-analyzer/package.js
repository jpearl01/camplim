Package.describe({
  name: 'cosmos:navigator-matrix-analyzer',
  version: '0.1.0',
  summary: 'Extract matrix params from path',
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
    , 'cosmos:navigator-phasor'  // ensure we have Nav.phasor
    , 'cosmos:navigator-query-analyzer' // need the `qs` module 
  ], 'client');

  api.addFiles([
    'client/matrix-analyzer.coffee'
  ], 'client');

}
