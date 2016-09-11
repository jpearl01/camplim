Package.describe({
  name: 'app:email',
  version: '0.1.0',
  summary: 'Configure Email',
  git: '',
  documentation: ''
});

Package.onUse(function(api) {
  api.versionsFrom('1.2');

  uses(api);

});

Package.onTest(function(api) {

  api.use(['tinytest'], 'server');

  uses(api);

});

function uses(api) {

  api.use(['coffeescript', 'email'], 'server');

  api.addFiles(['email.coffee', 'email-wish.coffee'], 'server');

}
