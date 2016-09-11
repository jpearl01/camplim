Package.describe({
  name: 'cosmos:form',
  version: '0.1.0',
  summary: 'A JS Form API for Templates',
  git: '',
  documentation: 'README.md'
});

var client = 'client'
var server = 'server'
var BOTH = [ client, server ]

function uses(api) {

  api.use([
    'coffeescript'
    , 'jagi:astronomy'
    , 'jagi:astronomy-validators'
    , 'aslagle:reactive-table@0.8.23'
    , 'cosmos:hoard'
  ], BOTH);

  api.use([
    'templating'
    , 'reactive-var'
    , 'sergeyt:typeahead@0.11.1_6'
    , 'cosmos:blaze-this'
    , 'cosmos:blaze-finders'
    , 'cosmos:moment-helpers'
  ], client);

  api.addFiles([
    'client/form.html'
    , 'client/form.coffee'

    , 'client/button-choices.html'
    // , 'client/button-choices.coffee'
    , 'client/select-choices.html'
    , 'client/select-choices.coffee'

    , 'client/bs-form-input.html'
    , 'client/bs-form-input.coffee'
    , 'client/bs-form-input-text.coffee'
    , 'client/bs-form-input-date.coffee'
    , 'client/bs-form-input-ref.coffee'

    , 'client/bs-textarea.html'
    , 'client/bs-textarea.coffee'

    , 'client/bs-select.html'
    , 'client/bs-select.coffee'

    , 'client/modal.html'
    , 'client/modal.coffee'

    , 'client/custom-props.html'
    , 'client/custom-props.coffee'

    , 'client/table.html'
    , 'client/table.coffee'

    , 'client/lists.coffee'
    
    , 'client/style.css'
  ], client);

  api.addFiles([
    'lib/validators.coffee'
    , 'lib/methods.coffee'
  ], BOTH);

  api.addFiles([
    'server/ref-search.coffee'
  ], server);

  api.export('ReactiveTable', server);

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
