Meteor.$fn.makePublication = publish = (name, selector = {}, fields = {}) ->
  collection = Meteor.$db[name]

  # publish the collection
  Meteor.publish name, (options={}) ->
    options = _.pick options, 'limit', 'sort'
    collection.find {}, options

  # publish a single document from the collection
  trim = if name[-1...] is 's' then -1
  singular = name[...trim]
  if name is 'bacteria' then singular = 'bacterium'
  Meteor.publish 'single-'  + singular, (id) ->
    if id? then collection.find _id:id

  # publish a reactive table for the collection
  ReactiveTable.publish name + '-table',
    -> if this?.userId? then collection
    -> selector  # selector function given to mongo
    -> transform:null # options
    -> fields

publish name for name in [ 'specimens', 'bacteria', 'clinicals', 'constructs', 'locations', 'projects' ] #, 'nucleics'

Meteor.$publishRecents 'all', {}
Meteor.$publishRecents 'data', from:'data'

Meteor.$publishRecents 'specimens'
Meteor.$publishRecents 'bacteria'
Meteor.$publishRecents 'clinicals'
Meteor.$publishRecents 'constructs'
Meteor.$publishRecents 'locations'
Meteor.$publishRecents 'projects'
