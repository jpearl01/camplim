Package.describe({
  name: 'cosmos:dashboard-recents',
  version: '0.1.0',
  summary: 'Dashboard Recently Viewed Things',
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
  api.addFiles('test/test-dashboard.js', 'client');

});

function uses(api) {
  api.use([
    'coffeescript'
    , 'mongo'
    , 'cosmos:dashboard'
    , 'cosmos:form'
  ], ['client', 'server'])

  api.use([
    'templating'
    , 'cosmos:blaze-this'
    , 'cosmos:hoard'
    , 'cosmos:moment-helpers'
  ], 'client')

  // api.use([
  //   'cosmos:navigator-location'
  // ], 'client', {weak:true});

  api.addFiles([
    'client/recent.html'
    , 'client/recent.coffee'
  ], 'client');


  api.addFiles([
    'lib/recents-collection.coffee'
  ], ['client', 'server']);

  api.addFiles([
    'server/dashboard-recents.coffee'
    , 'server/publish-recents.coffee'
    , 'server/recent-methods.coffee'
  ], 'server');

}
