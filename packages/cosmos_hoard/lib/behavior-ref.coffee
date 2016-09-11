createLabel = (string) ->
  # label = ''
  lastIndex = 0
  for ch,index in string
    if ch <= 'Z'
      if label?
        label = label + ' ' + string[lastIndex...index]
      else
        label = string[...index]
      lastIndex = index

  label =
    if   label.length is 0 then string
    else label[0].toUpperCase() + label[1...] + ' ' + string[lastIndex...]

  return label

events = {}

events.beforeInsert = events.beforeUpdate = ->
  console.log 'beforeInsert/Update !!!'
  @constructor.schema.behaviors.ref.ensureRefId this

defaults =
  type: 'string'
  to: 'name'
  idSuffix: 'Id'
  nameSuffix: 'Name'
  fromSuffix: 'From'
  # no `from` default... it's required

Astro.createBehavior
  name: 'ref'
  options: {}

  createSchemaDefinition: (behaviorOptions) ->
    # console.log 'createSchemaDefinition with:',behaviorOptions
    schema =
      fields: {}
      events: events

    for key,options of behaviorOptions
      # if no `from` option then, error somehow?

      idField = key + (options.idSuffix ? defaults.idSuffix)
      # options.idKey = idField
      # console.log '  id field:',idField
      schema.fields[idField] =
        type    : 'string'
        optional: true
        label   : options.label ? createLabel idField

      field = key + (options.nameSuffix ? defaults.nameSuffix)
      # options.nameKey = field
      # console.log '  name field:',field
      schema.fields[field] =
        type: (options.type ? defaults.type)
        # which collection is the ref'd thing from (example: 'projects')
        from: options.from
        # which field/key/prop is it in the other collection (default 'name')
        to  : (options.to ? defaults.to)
        # what is the name of the field we store the ref'd _id in? (example: 'projectId')
        id  : idField
        # what is the name of the ref (example: 'project')
        name: options.as ? key # key would be 'loggedBy' and `as` is 'member'
        label   : options.label ? createLabel field

      schema.fields[field].optional = true if options.required

      field = key + (options.fromSuffix ? defaults.fromSuffix)
      # options.fromKey = field
      # console.log '  from field:',field
      schema.fields[field] = type:'string', immutable:true, default: options.from

    return schema

  methods:
    ensureRefId: (doc) ->

      behaviorOptions = doc.constructor.schema.behaviors.ref.options # behavior.options

      for key,options of behaviorOptions
        console.log 'ensureRefId loop key:',key
        idField   = key + (options.idSuffix ? defaults.idSuffix)
        id = doc.get idField

        nameField = key + (options.nameSuffix ? defaults.nameSuffix)
        name = doc.get nameField
        console.log '  id,name:',id,name
        if name? and not id?
          console.log key + ' has name but not id...'
          # 1. try to search for it by name in other collection
          store = Meteor.$db[options.from]
          if store?
            console.log 'has a store'
            existing = store.find(name:name).fetch()
            console.log 'existing:',existing
            if existing?.length > 0
              id = existing[0]._id
              console.log 'id from existing:',id
            else
              # 2. insert it into the other collection
              id = store.insert name:name
              console.log 'id store.insert:',id

            # set id into it
            doc.set idField, id

          else # else show error somehow...
            console.log 'doesnt have store???',options.from

      return
