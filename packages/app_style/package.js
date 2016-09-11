Package.describe({
  name: 'app:style',
  version: '0.1.0',
  summary: 'Contains the styling for the app via Less for Bootstrap',
  git: '',
  documentation: ''
});

Package.onUse(function(api) {

  api.use([
    'less'
    , 'nemo64:bootstrap'
  ], 'client');

  api.addFiles([
    'custom.bootstrap.json'
    , 'custom.bootstrap.mixins.import.less'
    , 'custom.bootstrap.import.less'
    , 'bootstrap.import.less'
    , 'dashboard.import.less'
    , 'twitter-typeahead.import.less'
    , 'overrides.import.less'
    , 'style.less'
  ], 'client');

});

// Package.onTest(function(api) {
//   api.use('tinytest');
// });
