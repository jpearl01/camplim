# create the 'in-location' collection
collection = Meteor.hoard 'InLocation'

collection.allow
  insert: -> false
  update: -> false
  remove: -> false
