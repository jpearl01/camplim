
collection = Meteor.hoard 'projects'
collection.options = importAllowed:true
collection.allow
  insert: -> true
  update: -> true
  remove: -> false

Meteor.$things.project = collection.Thing = Project = Astro.Class

  name: 'Project'
  collection: collection
  fields:
    name:
      type: 'string'
      validator: [ Validators.required() ]
    description: 'string'
  behaviors:
    when: {}
    customs: {}
    refUpdate:
      project:
        in: [ 'specimens' ]
  indexes:
    name:
      fields:
        name:1
      options:
        unique:true

if Meteor.isServer
  # add a unique validator on the server only
  Project.extend
    validators:
      name: [ Validators.required(), Validators.unique() ]
