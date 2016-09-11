collection = Meteor.hoard 'collaborators'
collection.options = importAllowed:true

collection.allow
  insert: -> true
  update: -> true
  remove: -> false

Meteor.$things.collaborator = collection.Thing = Collaborator = Astro.Class

  name: 'Collaborator'
  collection: collection
  fields:
    name:
      type: 'string'
      validator: [ Validators.required() ]
    organization: 'string'
    phone:
      type:'string'
      # validator: Validators.phone() # TODO
    # address - make the Address then nest it here...
    # or, use a behavior to add the fields at the top level...
    address: 'string'
  behaviors:
    when: {}
    customs: {}
    refUpdate:
      collaborator: in: [ 'specimens' ]
  indexes:
    name:
      fields:
        name:1
