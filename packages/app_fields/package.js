Package.describe({
  name: 'app:fields',
  version: '0.1.0',
  summary: 'UI Field Helpers',
  git: '',
  documentation: ''
});

var client = 'client'
var server = 'server'
var BOTH = [client,server]

function uses(api) {

  // api.use([
  //   'coffeescript'
  //   , 'aslagle:reactive-table@0.8.23'
  // ], BOTH);
  //
  // api.use([
  //   'templating'
  //   , 'reactive-var'
  //   // , 'momentjs:moment@2.10.6'
  //   // , 'sergeyt:typeahead@0.11.1_6'
  //   , 'cosmos:blaze-profiles'
  //   , 'cosmos:blaze-this'
  //   , 'cosmos:blaze-finders'
  //   , 'cosmos:moment-helpers'
  // ], client);

  // api.addFiles([
  //
  //   // 'client/table.html'
  //   // , 'client/table.coffee'
  //
  // ], client);

  // api.addFiles([
  //   // 'server/refSearch.coffee'
  // ], server);

  // api.export('ReactiveTable', 'server');
}

Package.onUse(function(api) {
  api.versionsFrom('1.2');

  uses(api);

});

Package.onTest(function(api) {

  api.use([
    'tinytest', 'session', 'jquery'
  ], client);

  uses(api);

  api.addFiles([
    , 'test/templates.html'
    , 'test/templates.coffee'
    , 'test/tests.coffee'
  ], client)

  api.export(['Session', '$'], client);

});
