allow =
  insert: -> true
  update: -> true
  remove: -> false

# # Specimens # #

collection = Meteor.hoard 'specimens'
collection.allow allow

# instead, make an 'import' behavior which adds the import related info, based
# on the class's fields.
# hmm. i suppose we're just adding options to the collection, but, the field
# info is already being specified to the astronomy class... so, using a
# behavior allows using that info...
# collection.options =
#   import:


Meteor.$things.specimen = collection.Thing = Specimen = Astro.Class

  name: 'Specimen'
  collection: collection

  fields:
    _id:
      type:'string'
      optional:true
      label: 'ID'
    dateCollected:
      type: 'Date'
      optional:true
      label: 'Date Collected'
      validator: [ Validators.date(), Validators.beforeNow('Collected date') ]
    dateReceived:
      type: 'Date'
      label: 'Date Received'
      validator: [ Validators.date(), Validators.beforeNow('Received date') ]
      default: -> new Date()

  behaviors: # TODO: now that we can get the collection name in schema definition
             # we can use that as the default name and not use the `name` prop here
    seqid: name:'specimens', prefix:'S', startId:50000
    when: {}
    customs: {}
    # import:{}
    ref:
      project: from: 'projects'#, labelPrefix:'Project'
      collaborator: from: 'collaborators'#, labelPrefix: 'Collaborator'
      loggedBy: from: 'members', as: 'member'#, labelPrefix: 'Logged By'
      location: from: 'locations'#, labelPrefix: 'Location'
