Package.describe({
  name: 'cosmos:dashboard',
  version: '0.1.0',
  summary: 'Dashboard control',
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
  api.addFiles('test/test-dashboard.js', 'client');

});

function uses(api) {
  api.use([
    'coffeescript'
    , 'mongo'
  ], ['client', 'server'])

  api.use([
    'cosmos:hoard'
  ], ['client', 'server'], {weak:true});

  api.use([
    'templating'
    , 'tracker'
    , 'session'
    //, 'reactive-dict'
  ], 'client')

  // to get params we could use either router, so, abstract getParam on these?
  // could make a Params.get(string) thing which looks for both these at
  // construction time and complains if it doesn't find any.
  // how does Iron Router supply params again? I think the route action gets
  // them and then provides them to other stuff, so, it wouldn't be easy to
  // get the params from the router.
  // BUT, maybe no router is used, or no router params, and instead we get the
  // param from the Session, or some ReactiveDict made by the user. In that case,
  // they could set the implementation into the Params object.
  // could make this its own package, and, it could be an example of supporting
  // a variety of implementations of something...
  api.use([
    'cosmos:navigator-location'
    , 'kadira:flow-router'
  ], 'client', {weak:true});

  api.addFiles([
    'client/dashboard.coffee'
  ], 'client');


  api.addFiles([
    'lib/dashboard-collection.coffee'
  ], ['client', 'server']);

  api.addFiles([
    'server/dashboard-publish.coffee'
  ], 'server');

  api.export('Dashboard', ['client', 'server']);
}
