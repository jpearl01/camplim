# provide events in the schema definition
events = {}

# only do all this work for the server side which can use the raw collection
if Meteor.isServer

  # create the sequence collection
  Seq = new Mongo.Collection 'sequences'
  # get the raw collection so we can use findAndModify
  RawSeq = Seq.rawCollection()
  # wrap the function so we can use it synchronously
  findAndModify = Meteor.wrapAsync RawSeq.findAndModify, RawSeq

  # only the server makes this function and it ensures the sequence document
  # for the related collection exists. after its initial run this will never
  # actually do anything for the life of the app.
  createSchemaDefinition = (options) ->

    # NOTE:
    #   can't use collection name as the default `name` because we can't get
    #   the collection object within the createSchemaDefinition function
    #   so, that's why it's a required behavior option

    # ensure we have the sequencer
    name = options.name # ? collection._name
    hasIt = Seq.findOne(_id:name)?
    unless hasIt then Seq.insert _id:name, seq:options.startId

    # our schema only has the event to contribute
    return events:events

  # this is where the real work happens. assign the next _id to the document
  events.beforeInsert = ->
    # if it already has an _id then we don't need to set one
    if this._id? then return

    # get our options so we know the `name` to use
    options = @constructor.getBehavior('seqid').options

    # be nice if we could get the collection name by default...
    # we can get it here, but, we can't get it in the createSchemaDefinition
    # so, we can't use it here. :(
    name = options.name # this.constructor.getCollection()._name

    # splat the args from the array because the npm mongo driver module
    # wants each of the values individually instead of in an object (annoying)
    # NOTE: i could pass them to the function directly but I think it's more
    #       readable this way to see each thing...
    args = [
      {_id:name}     # query
      {}             # sort
      {$inc: seq:1 } # update
      {new:true}     # options
    ]

    result = findAndModify args...

    # set the id if we received a result, convert to a string
    if result?.seq? then this._id = options.prefix + result.seq

    return

# create the behavior on both client and server so the dev doesn't need to use
# `if Meteor.isServer then thing.extend(...)` to add it to only the server.
# it doesn't *do* anything on the client side tho.
Astro.createBehavior
  name: 'seqid'
  # by default the starting id is zero.
  options: startId:0, prefix:''
  createSchemaDefinition: createSchemaDefinition
