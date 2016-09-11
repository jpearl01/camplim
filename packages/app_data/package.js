Package.describe({
  name: 'app:data',
  version: '0.1.0',
  summary: 'App Data dashboard context',
  git: '',
  documentation: ''
});

client = 'client'
server = 'server'
both   = [ client, server ]

Package.onUse(function(api) {
  api.versionsFrom('1.2');

  api.use([
    'templating'
    , 'reactive-var'
  ], client);

  api.use([
    'mongo'
    , 'coffeescript'
    , 'cosmos:dashboard'
    , 'cosmos:dashboard-recents'
    , 'app:fields'
    , 'jagi:astronomy'
    , 'jagi:astronomy-validators'
    , 'cosmos:form'
  ], both);

  api.addFiles([

    // contains the profiles and script work for all add/view templates
    'client/view/AddOrView.coffee'

    // contains the input fields for the type
    , 'client/view/specimen-inputs.html'
    , 'client/view/project-inputs.html'
    , 'client/view/location-inputs.html'
    , 'client/view/bacteria-inputs.html'
    , 'client/view/construct-inputs.html'
    , 'client/view/clinical-inputs.html'

    // contains the string-verifiers
    , 'client/view/specimen-inputs.coffee'
    , 'client/view/project-inputs.coffee'
    , 'client/view/location-inputs.coffee'
    , 'client/view/bacteria-inputs.coffee'
    , 'client/view/construct-inputs.coffee'
    , 'client/view/clinical-inputs.coffee'

    // ParentSpecimen template
    , 'client/view/parent.html'
    , 'client/view/parent.coffee'
    , 'client/view/parent.css'

    // contains the general list functionality for all table/lists
    , 'client/list/lists.coffee'

    // contains the specific fields info for the tables
    , 'client/list/projects.coffee'
    , 'client/list/specimens.coffee'
    , 'client/list/bacteria.coffee'
    , 'client/list/constructs.coffee'
    , 'client/list/locations.coffee'
    , 'client/list/clinicals.coffee'

    // contains the modal settings for creating new thing above another form
    , 'client/view/project-modal.coffee'
    , 'client/view/location-modal.coffee'

    // for creating a new child thing from its parent's view
    , 'client/view/child-button.html'
    , 'client/view/child-button.coffee'

  ], client);

  api.addFiles([
    'lib/collections.coffee'
    , 'lib/projects-collection.coffee'
    , 'lib/specimens-collection.coffee'
    , 'lib/bacteria-collection.coffee'
    , 'lib/clinicals-collection.coffee'
    , 'lib/constructs-collection.coffee'
    , 'lib/locations-collection.coffee'
    , 'lib/in-location-collection.coffee'
  ], both);

  api.addFiles([
    'server/dashboard.coffee'
    , 'server/publish.coffee'
    , 'server/publish-in-location.coffee'
    , 'server/recent-methods.coffee'
    , 'server/search-methods.coffee'
  ], server);

});

Package.onTest(function(api) {
  api.use(['tinytest'], client);
  //api.addFiles('dashboard-sample-tests.js', 'client');
});
