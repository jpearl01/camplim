Package.describe({
  name: 'cosmos:navigator-lasimii',
  version: '0.1.0',
  summary: 'Single hierarchical route for Dashboard app',
  git: '',
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.2');

  uses(api);

  api.addFiles([
    'client/sample/sample.html'
  ], 'client', {devonly:true});

  api.export(['Nav'], 'client');

});

Package.onTest(function(api) {

  uses(api);

  api.use('tinytest', 'client');

  api.addFiles('test/tests.coffee', 'client');

});

// do the same for both onUse and onTest so we can get stuff from shared object
// without exporting it to the test side of the package (annoying)
function uses(api) {

  api.use([
    'coffeescript'
    , 'tracker'
    , 'templating'
    , 'reactive-dict'
    , 'cosmos:navigator-location'  // uses Nav
    , 'cosmos:navigator-params'    // stores params into Nav
    , 'cosmos:navigator-phasor'    // uses Nav.phasor
  ], 'client');

  api.addFiles([
    'client/lasimii.coffee'
    , 'client/helpers.coffee'
  ], 'client');

}
