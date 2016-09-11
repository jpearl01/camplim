#   #    #
# EVENTS #
#   #    #

events = {}

events.beforeInsert = ->
  # doc = this
  # Class = doc.constructor
  # Class.getBehavior('when').setCreationInfo doc
  @constructor.getBehavior('when').setCreationInfo this


events.beforeUpdate = ->
  # doc = this
  # Class = doc.constructor
  # Class.getBehavior('when').setModificationInfo doc
  @constructor.getBehavior('when').setModificationInfo this

# # Ops
#
# add a 'create' op in the Ops collection
# events.afterInsert = ->

# add an 'update' op in the Ops collection (collapse with recent for same)
# events.afterUpdate = ->


#    #     #
# BEHAVIOR #
#    #     #

Astro.createBehavior
  name: 'when'
  methods:
    setCreationInfo: (doc) ->

      Class = doc.constructor
      classBehavior = Class.getBehavior 'when'
      options = classBehavior.options
      date = new Date()

      doc.set options.created.at, date if options.created.at?

      if options.created.by?
        byId = options.created.by + 'Id'
        byName = options.created.by + 'Name'
        # don't overwrite special values used by User/Member
        set = {}
        set[byId] = Meteor.userId() unless doc.get(byId) is '0'
        set[byName] = Meteor.user().profile?.name unless doc.get(byName) is 'User System'
        doc.set set
        # doc.set byId, Meteor.userId() unless doc.get(byId)? is '0'
        # doc.set byName, Meteor.user().profile?.name unless doc.get(byName)? 'User System'
        # # no need to set the + 'From' as 'members'... it's assumed...

    setModificationInfo: (doc) ->
      Class = doc.constructor
      classBehavior = Class.getBehavior 'when'
      options = classBehavior.options
      modified = doc.getModified()

      if modified? and Object.keys(modified).length > 0
        update = {}
        update[options.updated.at] = new Date() if options.updated.at?
        # doc.set options.updated.at, new Date() if options.updated.at?
        if options.updated.by?
          update[options.updated.by + 'Id'] = Meteor.userId()
          update[options.updated.by + 'Name'] = Meteor.user().profile?.name
          # doc.set options.updated.by + 'Id', Meteor.userId()
          # doc.set options.updated.by + 'Name', Meteor.user().profile?.name
          # # no need to set the + 'From' as 'members'... it's assumed...
        doc.set update

  options:
    created:
      at: 'createdAt'
      by: 'createdBy'
    updated:
      at: 'updatedAt'
      by: 'updatedBy'

  createSchemaDefinition: (options) ->

    schemaDefinition =
      fields: {}
      events: events

    if options.created.at?
      # Add a field for storing a creation date.
      schemaDefinition.fields[options.created.at] =
        type: 'date', immutable: true, default: null

    if options.created.by?
      # Add a field for storing a creation date.
      schemaDefinition.fields[options.created.by + 'Id'] =
        type: 'string', immutable: true, default: null
        # can we do this.userId for default? or a function?

      schemaDefinition.fields[options.created.by + 'Name'] =
        type: 'string', immutable: true, default: null


    if options.updated.at?
      # Add a field for storing a creation date.
      schemaDefinition.fields[options.updated.at] =
        type: 'date', optional: true

    if options.updated.by?
      # Add a field for storing a creation date.
      schemaDefinition.fields[options.updated.by + 'Id'] =
        type: 'string', optional: true

      schemaDefinition.fields[options.updated.by + 'Name'] =
        type: 'string', optional: true

    return schemaDefinition
