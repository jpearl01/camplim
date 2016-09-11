Package.describe({
  name: 'cosmos:navigator-query-analyzer',
  version: '0.1.0',
  summary: 'Analyze query string and store values into Nav.',
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
    , 'cosmos:navigator-location'  // ensure we have Nav
    , 'cosmos:navigator-query'     // ensure we have Nav query functions
    , 'cosmos:navigator-phasor'    // ensure we have Nav.phasor functions
  ], 'client');

  api.addFiles([
    'package.browserified.js'   // via npm module `bonce`
    , 'client/query-analyzer.coffee'
  ], 'client');

}
