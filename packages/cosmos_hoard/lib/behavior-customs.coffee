Astro.createBehavior
  name: 'customs'
  options: key:'custom'

  createSchemaDefinition: (options) ->
    # console.log 'parent behavior createSchemaDefinition with:',options
    prefix = options.key
    schema =
      fields: {}

    schema.fields[options.key] = type:'object', optional:true, default: -> {}

    schema.methods =
      getCustomPrefix: -> prefix
      getCustomKeys: ->
        # create a dependency on changes (modifiers) for returning these keys
        if Meteor.isClient then @_hasChanges.get()
        (name for own name of @get prefix)
      getCustomNameFor: (key) -> prefix + '.' + key
      hasCustomKey: (key) -> @[prefix][key]?
      hasCustomValue: (key) -> @[prefix][key]? # @string? or @date?
      getCustomValue: (key) ->
        custom = @[options.key]
        custom[key].date ? custom[key].string
      getCustomObject: (key) -> @[prefix][key]

    schema.events =
      beforeSet: (event) ->
        # ignore set events during init
        if this._isInit then return
        # TODO:
        #  allow behavior's options to provide other converters
        #  basically store functions which run on the key and value and return
        #  the new value when they handle it.
        #  run each pair on array of functions until the conversion happens.
        #  the options can provide an array of the functions to add
        #
        # probably need reverse converters, value getters, for the getCustomValue to use.

        # console.log 'beforeSet:',event

        if event.data.fields[prefix]?
          customFields = event.data.fields[prefix]
          for own key,value of customFields
            # console.log 'beforeSet for key:',key
            if typeof(value) is 'string'
              customFields[key] = type:'text',string:value
            else if value instanceof Date
              customFields[key] = type:'date',date:value

        else
          fields = event.data.fields
          for own key,value of fields when key[...prefix.length] is prefix and key.length > prefix.length
            # console.log 'beforeSet for key:',key
            if typeof(value) is 'string'
              fields[key] = type:'text',string:value
            else if value instanceof Date
              fields[key] = type:'date',date:value
            # else leave alone...

    return schema
