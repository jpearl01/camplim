
collection = Meteor.hoard 'clinicals'
collection.options = importAllowed:true

collection.allow
  insert: -> true
  update: -> true
  remove: -> false

Meteor.$things.clinical = collection.Thing = Clinical = Astro.Class

  name: 'Clinical'
  collection: collection

  fields:
    parentId  : 'string'
    tissue   : 'string'
    subject    : 'string'
    indication : 'string'
    surgeon: 'string'
    place: 'string'
    dob: 'Date'
    dateFrozen: 'Date'
    sex:
      type: 'string'
      validator: Validators.choice [ 'Male', 'Female' ]

  behaviors:
    seqid: name:'clinicals', prefix:'CS', startId:50000
    when: {}
    customs: {}
    parent:
      $default            : 'Specimen'
      Specimen            : db: 'specimens', view:'specimen'
      'Clinical Specimen' : db: 'clinicals', view:'clinical'
      Bacteria            : db: 'bacteria',  view:'bacterium'
      'Genomic Construct' : db: 'constructs',view:'construct'

collection.import = (allData) ->
  console.log 'import clinical',allData
  thingData = allData.clinicals
  # only import when they specified an _id
  # TODO: instead, look for something other than location. that's not enough.
  unless thingData?._id? then return

  # is it from a parent specimen?
  if allData.specimens?._id?
    thingData.parentId = allData.specimens._id
    thingData.parentType = 'Specimen'

  thing = new Clinical
  thing.set thingData

  selector = thing._getModifiers()?.$set
  if Object.keys(selector).length > 0 and collection.find(selector).count() > 0
    return

  console.log 'save imported clinical'
  thing.save()
  # Meteor.call 'saveThing', thing, (error, result) ->
  #   if error?
  #     console.log 'Error:',error
  #   else
  #     ; # blah
