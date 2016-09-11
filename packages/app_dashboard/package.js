Package.describe({
  name: 'app:dashboard',
  version: '0.1.0',
  summary: 'App dashboard',
  git: '',
  documentation: ''
});

var client = 'client'
var server = 'server'
var BOTH   = [ client, server ]

Package.onUse(function(api) {
  api.versionsFrom('1.2');

  // BOTH CLIENT AND SERVER
  api.use([
    'coffeescript'
    , 'cosmos:dashboard'
    , 'cosmos:hoard'
  ], BOTH );

  // api.addFiles([
  // ], BOTH);

  // CLIENT
  api.use([
    'templating'
    , 'tracker'
    , 'reactive-var'
    , 'cosmos:navigator-location'
  ], client);

  api.addFiles([
    'client/default-location.coffee'
    , 'client/footer.html'
    , 'client/footer.coffee'
    , 'client/footer.css'
  ], client);

  // SERVER
  // api.use([
  // ], server);

  api.addFiles([
    'server/dashboard.coffee'
  ], server);

});

Package.onTest(function(api) {
  api.use(['tinytest'], 'client');
  //api.addFiles('dashboard-sample-tests.js', 'client');
});
