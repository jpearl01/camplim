Package.describe({
  name: 'cosmos:navigator-hash',
  version: '0.1.0',
  summary: 'Add reactive/non-reactive hash storage.',
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
    , 'templating'                       // helpers need Template.registerHelper
    , 'reactive-var'                     // hash stored in a ReactiveVar
    , 'cosmos:navigator-location@0.1.0'  // ensure we have Nav
  ], 'client');

  api.addFiles([
    'client/hash.coffee'
    , 'client/helpers.coffee'
  ], 'client');

}
