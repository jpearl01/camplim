Package.describe({
  name: 'app:people',
  version: '0.1.0',
  summary: 'App People dashboard context',
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
  ], client);

  api.use([
    'mongo'
    , 'accounts-base' // because we do Meteor.users
    , 'coffeescript'
    , 'jagi:astronomy'
    , 'jagi:astronomy-validators'
    , 'cosmos:dashboard'
    , 'cosmos:dashboard-recents'
    , 'app:fields'
    , 'app:data' // for now, it makes functions we use. later, move them to app:dashboard
  ], both);

  api.addFiles([
    'client/view/collaborator-inputs.html'
    , 'client/view/collaborator-inputs.coffee'

    , 'client/view/member-inputs.html'
    , 'client/view/member-inputs.coffee'

    , 'client/list/lists.coffee'
    , 'client/list/collaborators.coffee'
    , 'client/list/members.coffee'

    // contains the modal settings for creating new thing above another form
    , 'client/view/member-modal.coffee'
    , 'client/view/collaborator-modal.coffee'

    // subscribes to MyMember for the current user
    , 'client/subscribe-my-member.coffee'

  ], client);

  api.addFiles([
    'lib/members-collection.coffee'
    , 'lib/collaborators-collection.coffee'
  ], both);

  api.addFiles([
    'server/dashboard.coffee'
    , 'server/publish.coffee'
    , 'server/recent-methods.coffee'
  ], server);

});

Package.onTest(function(api) {
  api.use(['tinytest'], client);
  //api.addFiles('dashboard-sample-tests.js', 'client');
});
