Package.describe({
  name: 'cosmos:dashboard-bootstrap',
  version: '0.1.0',
  // Brief, one-line summary of the package.
  summary: 'Dashboard UI ala Bootstrap',
  // URL to the Git repository containing the source code for this package.
  git: '',
  // By default, Meteor will default to using README.md for documentation.
  // To avoid submitting documentation, set this field to null.
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.2');

  api.use([
    'coffeescript'
    , 'cosmos:dashboard'
  ], ['client', 'server'])

  api.use([
    'templating'
    , 'meteor'
    , 'reactive-dict'
    , 'reactive-var'
  ], 'client')

  api.use([
    'cosmos:navigator-location'
    , 'cosmos:navigator-phasor'
  ], 'client', {weak:true})

  api.addFiles([
    , 'client/init.coffee'
    , 'client/layout.html'
    , 'client/layout.coffee'
    , 'client/header.html'
    , 'client/header.coffee'
    , 'client/middle.html'
    , 'client/middle.coffee'
    , 'client/sidebar.html'
    , 'client/sidebar.coffee'
    , 'client/footer.html'
    , 'client/footer.coffee'
    , 'client/footer.css'
    , 'client/notices.html'
    , 'client/notices.coffee'

    , 'client/user/profile.html'
    , 'client/user/profile.coffee'
    , 'client/user/settings.html'
    , 'client/user/settings.coffee'

  ], 'client');

  api.addFiles([
    // temporary, need to move user stuff to cosmos:dashboard-users + -bootstrap
    'server/dashboard.coffee'
  ], 'server');

});

Package.onTest(function(api) {
  api.use('tinytest', 'client');
  api.use('cosmos:dashboard-bootstrap', 'client');
  api.addFiles('test/dashboard-bootstrap-tests.js', 'client');
});
