Package.describe({
  name: 'cosmos:blaze-finders',
  version: '0.1.0',
  summary: 'Adds reactive safe property finders',
  git: 'http://github.com/elidoran/cosmos-blaze-finders',
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.2');

  uses(api);

});

Package.onTest(function(api) {

  uses(api);

  api.use(['tinytest'], 'client');

  api.addFiles([
    , 'test/tests.coffee'
  ], 'client');

});

function uses(api) {
  api.use(['coffeescript', 'templating'], 'client')

  api.addFiles('client/blaze-finders.coffee', 'client');

}
