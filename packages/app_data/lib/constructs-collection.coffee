
collection = Meteor.hoard 'constructs'
collection.options = importAllowed:true
collection.allow
  insert: -> true
  update: -> true
  remove: -> false

Meteor.$things.construct = collection.Thing = Construct = Astro.Class

  name: 'Construct'
  collection: collection
  fields:
    parentId  : 'string'
    genotype   : 'string'
    plasmid    : 'string'
    resistance: # TODO: look at importa data, is it a percentage?
      type: 'string'
      # validator: [ Validators.gte(0), Validators.lte(100) ]
    concentration: # TODO: look at importa data, is it a percentage?
      type: 'string'
      # validator: [ Validators.gte(0), Validators.lte(100) ]
    dateMade:
      type: 'Date'
      validator: Validators.beforeNow('Date Made')

  behaviors:
    seqid: name:'constructs', prefix:'GC', startId:50000
    when: {}
    customs: {}
    parent:
      $default            : 'Specimen'
      Specimen            : db: 'specimens', view:'specimen'
      'Clinical Specimen' : db: 'clinicals', view:'clinical'
      Bacteria            : db: 'bacteria',  view:'bacterium'
      'Genomic Construct' : db: 'constructs',view:'construct'
    ref:
      madeBy: from: 'members', as: 'member'
      location: from: 'locations'

collection.import = (allData) ->
  console.log 'import construct'
  thingData = allData.constructs
  # only import when they specified an _id
  # TODO: instead, look for something other than location. that's not enough.
  unless thingData._id? then return

  # is it from a parent specimen?
  if allData.specimens?._id?
    thingData.parentId = allData.specimens?._id
    thingData.parentType = 'Specimen'

  thing = new Construct
  thing.set thingData

  selector = thing._getModifiers()?.$set
  if Object.keys(selector).length > 0 and collection.find(selector).count() > 0
    return

  console.log 'save imported construct'
  # thing.save()
  # Meteor.call 'saveThing', thing, (error, result) ->
  #   if error?
  #     console.log 'Error:',error
  #   else
  #     ; # blah
