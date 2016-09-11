Package.describe({
  name: 'cosmos:dashboard-entry-bootstrap',
  version: '0.1.0',
  summary: 'Dashboard Entry UI ala Bootstrap',
  git: '',
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.2');

  uses(api);

});

Package.onTest(function(api) {
  api.use('tinytest', 'client');
  uses(api);
});

function uses(api) {

  api.use([
    'coffeescript'
    , 'templating'
    , 'cosmos:dashboard-entry'
  ], 'client');


  api.addFiles([
    'client/dashboard.css'

    , 'client/login.html'
    , 'client/login.coffee'

    , 'client/register.html'
    , 'client/register.coffee'

    , 'client/forgot.html'
    , 'client/forgot.coffee'

    , 'client/enroll.html'
    , 'client/enroll.coffee'

    , 'client/verify.html'
    , 'client/verify.coffee'

    , 'client/reset.html'
    , 'client/reset.coffee'

  ], 'client');
}
