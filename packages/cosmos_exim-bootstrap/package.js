Package.describe({
  name: 'cosmos:exim-bootstrap',
  version: '0.1.0',
  summary: 'Export Import Operations Dashboard UI',
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

function uses(api) {

  api.use([
    'templating'
    , 'reactive-var'
    , 'reactive-dict'
    , 'cosmos:blaze-this'
    , 'cosmos:form'
    , 'cosmos:hoard'
  ], 'client')

  api.addFiles([
    'client/import-maps.html'
    , 'client/import-maps.coffee'

    , 'client/map-form/map-field.html'
    , 'client/map-form/map-field.coffee'

    , 'client/map-form/style.css'


    , 'client/start-import.html'
    , 'client/start-import.coffee'

    , 'client/imports.html'
    , 'client/imports.coffee'

  ], 'client');

  api.use([
    'coffeescript'
    , 'cosmos:exim'
  ], ['client', 'server'])

  api.addFiles([
  ], ['client', 'server']);


  api.use([
  ], 'server')

  api.addFiles([

  ], 'server')

}

/*

can use the table stuff to display a list of pending im/ex, im/ex maps
can use custom prop stuff to add fields with collection.
have to use select for collection names.
have to select it repeatedly...
or, make something new... choose a collection name, then, use customs to choose
the file's column header and the collections property name.

*/
