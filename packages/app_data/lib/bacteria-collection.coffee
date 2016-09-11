
collection = Meteor.hoard 'bacteria'
collection.options = importAllowed:true
collection.allow
  insert: -> true
  update: -> true
  remove: -> false

Meteor.$things.bacterium = collection.Thing = Bacterium = Astro.Class

  name: 'Bacteria'
  collection: collection
  fields:
    species   : 'string'
    strain    : 'string'
    phenotype : 'string'
    dateFrozen: 'date'

  behaviors:
    seqid: name:'bacteria', prefix:'BS', startId:50000
    when:{}
    customs: {}
    parent:
      $default            : 'Specimen'
      Specimen            : db: 'specimens', view:'specimen'
      'Clinical Specimen' : db: 'clinicals', view:'clinical'
      Bacteria            : db: 'bacteria',  view:'bacterium'
      'Genomic Construct' : db: 'constructs',view:'construct'
    ref:
      storedBy: from: 'members', as: 'member'
      location: from: 'locations'

collection.import = (allData) ->
  console.log 'import bacterium',allData
  thingData = allData.bacteria
  # only import when they specified an _id
  # TODO: instead, look for something other than location. that's not enough.
  unless thingData._id? then return

  # is it from a parent specimen?
  if allData.specimens?._id?
    thingData.parentId = allData.specimens?._id
    thingData.parentType = 'Specimen'

  thing = new Bacterium
  thing.set thingData

  selector = thing._getModifiers()?.$set
  if Object.keys(selector).length > 0 and collection.find(selector).count() > 0
    return

  console.log 'save imported bacteria'
  thing.save()
  # Meteor.call 'saveThing', thing, (error, result) ->
  #   if error?
  #     console.log 'Error:',error
  #   else
  #     ; # blah
