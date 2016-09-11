
collection = Meteor.hoard 'locations'
collection.options = importAllowed:true

collection.allow
  insert: -> true
  update: -> true
  remove: -> false

Meteor.$things.location = collection.Thing = Location = Astro.Class

  name: 'Location'
  collection: collection
  fields:
    name:
      type:'string'
      validator: Validators.required()
    room : 'string'
    rack : 'string'
    shelf: 'string'
    box  : 'string'
    cell : 'string'
    storageType:
      type: 'string'
      optional:true
      validator: Validators.choice [ 'Fridge', 'Freezer' ]
      default: -> 'Freezer'
  behaviors:
    when: {}
    customs: {}
    refUpdate:
      location:
        in: [ 'specimens', 'bacteria', 'constructs' ]
        # with: 'name'
        # use defaults 'Id' + 'Name' to get id/field
        # id: 'locationId'
        # field: 'locationName'
  indexes:
    name:
      fields:
        name:1
      options:
        unique:true
