events = {}

events.afterUpdate = (e) ->
  @constructor.schema.behaviors.refUpdate.updateRefs this, e.target._modifiers

defaults =
  with: 'name'
  # no default for `in`, it must be specified

Astro.createBehavior
  name: 'refUpdate'
  options: {}

  createSchemaDefinition: (behaviorOptions) ->
    # console.log 'createSchemaDefinition with:',behaviorOptions
    schema =
      fields: {}
      events: events

    # if no `in` option then, error somehow?

    # let's review the options and fill them in based on defaults
    for name,options of behaviorOptions
      # name = the name of the thing
      # options.in = the name, or array of names, of the other collection to update
      # options.with = the name of the local field to put into the other field
      # options.id = the name of the id ref field in the other collection
      # options.field = the name of the ref field in the other collection

      # use defaults to generate the keys and store them for repeated
      options.id   ?= name + 'Id'
      options.name ?= name + 'Name'
      options.with ?= defaults.with

      unless Array.isArray(options.in) then options.in = [ options.in ]

    # we're not adding any fields to the schema
    return schema

  methods:
    updateRefs: (doc, modifiers) ->

      for name,options of doc.constructor.schema.behaviors.refUpdate.options
        # name = the name of the thing
        # options.in = the name, or array of names, of the other collection to update
        # options.with = the name of the local field to put into the other field
        # options.id = the name of the id ref field in the other collection
        # options.name = the name of the ref field in the other collection

        # 1. check if there's a modifier for our field
        unless modifiers?.$set?[options.with]? then continue

        # 2. what is the value we're updating
        value = doc.get options.with

        # 3. build selector to find ones in need of updating
        selector = $and: [ {}, {} ]
        selector.$and[0][ options.id ] = doc._id
        selector.$and[1][ options.name ] = $ne: value

        # 4. build the update
        update = $set:{}
        update.$set[options.name] = value

        # 5. do an update for each collection
        for collectionName in options.in

          # 6. get the collection
          collection = Meteor.$db[collectionName]

          # 7. call update with selector and update set
          collection.update selector, update
