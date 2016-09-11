Package.describe({
  name: 'cosmos:hoard',
  version: '0.1.0',
  summary: 'Collection Help',
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
  // api.addFiles('test/test-dashboard.js', 'client');

});

function uses(api) {

  api.use([
    'coffeescript'
    , 'mongo'
    , 'jagi:astronomy'
    , 'jagi:astronomy-validators'
  ], ['client', 'server'])

  api.addFiles([
    'lib/store.coffee'
    , 'lib/types.coffee'
    , 'lib/behavior-when.coffee'
    , 'lib/behavior-ref.coffee'
    , 'lib/behavior-ref-update.coffee'
    , 'lib/behavior-parent.coffee'
    , 'lib/behavior-seqid.coffee'
    , 'lib/behavior-customs.coffee'
  ], ['client', 'server']);

  // TODO: publish the Ops stuff...

}
