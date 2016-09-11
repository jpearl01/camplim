Package.describe({
  name: 'cosmos:when',
  version: '0.1.0',
  summary: 'Store created/updated info for all collections',
  git: '',
  documentation: ''
});

var client = 'client'
var server = 'server'

function uses(api) {

  api.use([
    'coffeescript'
    , 'mongo'
    // , 'momentjs:moment@2.11.0'
    // , 'matb33:collection-hooks'
  ], client);

  api.addFiles('when.coffee', client);

}

Package.onUse(function(api) {
  api.versionsFrom('1.2');

  uses(api);

});

Package.onTest(function(api) {

  api.use(['tinytest'], client);

  uses(api);

  api.addFiles([  ], client)

});
