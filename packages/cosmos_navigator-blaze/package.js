Package.describe({
  name: 'cosmos:navigator-blaze',
  version: '0.1.0',
  summary: 'Blaze template rendering control',
  git: 'http://github.com/elidoran/cosmos-navigator-blaze',
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.2');

  api.use([
    'blaze',        // Blaze.renderWithData and Blaze.remove
  ], 'client');

  api.use([
    'cosmos:navigator-location'
    , 'cosmos:navigator-phasor'
  ], 'client', {weak:true});

  uses(api);
});

Package.onTest(function(api) {

  uses(api);

  api.use([
    'tinytest'
    , 'templating'
    , 'jquery'
    , 'cosmos:navigator-location'
    , 'cosmos:navigator-phasor'
  ], 'client');

  api.addFiles([
    'test/tests.coffee'
    , 'test/templates.html'
  ], 'client');

});

function uses(api) {
  api.use([
    'coffeescript@1.0.11',
    'reactive-dict',      // holds view data context values
  ], 'client');

  api.addFiles([
    'client/view.coffee',
    'client/view-phases.coffee'
  ], 'client');

  api.export('Views', 'client');
}
