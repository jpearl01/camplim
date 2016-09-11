Meteor.$fn = {}
Meteor.$db = {}
Meteor.$things = {}

# use a transform to provide helper functions on the op documents returned?
Meteor.$db.ops = Ops = new Meteor.Collection 'ops'
deny = -> false
Ops.allow insert:deny, update:deny, remove:deny

Meteor.hoard = (name, options = {}) ->

  Meteor.$db[name] = store = new Meteor.Collection name, options

  return store
