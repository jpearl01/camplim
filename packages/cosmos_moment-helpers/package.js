Package.describe({
  name: 'cosmos:moment-helpers',
  version: '0.1.0',
  summary: 'Moment format and parse helpers',
  git: '',
  documentation: ''
});

var client = 'client'
var server = 'server'

Package.onUse(function(api) {
  api.versionsFrom('1.2');

  uses(api);

});

Package.onTest(function(api) {

  api.use(['tinytest'], client);

  uses(api);

  api.addFiles([  ], client)

});

function uses(api) {

  api.use([
    'coffeescript'
    , 'templating'
    , 'momentjs:moment@2.11.0'
    , 'cosmos:blaze-profiles'
  ], client);

  api.addFiles('moment.coffee', client);

}
