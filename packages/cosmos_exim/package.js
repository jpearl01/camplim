Package.describe({
  name: 'cosmos:exim',
  version: '0.1.0',
  summary: 'Export Import Operations',
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

});

Npm.depends({
  'watch.io' : '1.0.7'
  , 'each-part' : '0.8.1'
  , 'through2' : '2.0.0'
});

function uses(api) {

  api.use([
    'coffeescript'
    , 'mongo'
    , 'jagi:astronomy'
    , 'jagi:astronomy-validators'
  ], ['client', 'server']);

  api.use([
    'cosmos:hoard'
  ], ['client', 'server'], {weak:true});

  api.addFiles([
    'lib/collections.coffee'
  ], ['client', 'server']);


  api.use([
    'differential:cluster@1.0.1'
    , 'differential:workers@2.0.5'
  ], 'server');

  api.addFiles([
    'server/dashboard-menu.coffee'
    , 'server/publish.coffee'
    , 'server/import-job.coffee'
    , 'server/map-methods.coffee'
    // , 'server/export-job.coffee'
    , 'server/imports-watcher.coffee'
    , 'server/search-maps.coffee'
  ], 'server');


  api.export(['EximFiles', 'EximOps', 'ImportMaps', 'ExportMaps', 'Jobs'], ['client', 'server']);
}
