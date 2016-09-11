
# TODO: on save (insert/update) ensure parentId is in parentType's collection

Astro.createBehavior
  name: 'parent'
  options: {}

  createSchemaDefinition: (behaviorOptions) ->
    # console.log 'parent behavior createSchemaDefinition with:',behaviorOptions
    schema =
      fields: {}
      events: {} # events
      methods: {}

    # 1. create parentId field
    schema.fields.parentId = type:'string', optional:true

    # 2. create parentType field (with choices validator when multiple types)
    typeNames = Object.keys behaviorOptions

    index = typeNames.indexOf '$default'
    if index > -1 then typeNames.splice index, 1

    if typeNames.length > 1
      schema.fields.parentType =
        type:'string'
        optional:true
        default: behaviorOptions.$default
        validator: Validators.choice typeNames

    else if typeNames.length is 1
      schema.fields.parentType =
        type:'string'
        optional:false
        immutable:true
        default: behaviorOptions[typeNames[0]]

    schema.methods.getParentItem = -> behaviorOptions[@parentType].view

    schema.methods.getParentName = -> behaviorOptions[@parentType].db

    return schema

  # methods:
  #
