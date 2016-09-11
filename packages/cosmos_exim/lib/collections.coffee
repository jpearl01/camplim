create = (name) -> if Meteor.hoard? then Meteor.hoard name else new Mongo.Collection name

EximFiles  = create 'eximFiles'
EximOps    = create 'eximOps'
ImportMaps = create 'importMaps'
ExportMaps = create 'exportMaps'

deny = -> false

EximFiles.allow  insert:deny, update:deny, remove:deny
EximOps.allow    insert:deny, update:deny, remove:deny
ImportMaps.allow insert:deny, update:deny, remove:deny
ExportMaps.allow insert:deny, update:deny, remove:deny

if Meteor.isServer
  EximFiles._ensureIndex {path:1}, unique:true
  EximFiles._ensureIndex type:1
  EximOps._ensureIndex type:1, status:1, userId:1
  # ImportMaps._ensureIndex creating:1
  # ExportMaps._ensureIndex creating:1

Meteor.$things.importMapField = ImportMapField = Astro.Class
  name: 'ImportMapField'
  fields:
    foreignName:
      type:'string'
      validator:Validators.required('Must specify the name of the import column')
    localName:
      type:'string'
      validator:Validators.required('Must specify the name to store the value as')
    localCollection:
      type:'string'

Meteor.startup ->
  # let's use the names of collections specifying they can do imports
  names = (name for name,db of Meteor.$db when db?.options?.importAllowed)
  names.sort()
  if names.length > 0
    # enhance the localCollection with a validator requiring the name be one of the above
    ImportMapField.extend
      fields: localCollection:
        type:'string'
        validator:Validators.choice names

Meteor.$things.importMap = ImportMap = Astro.Class
  name: 'ImportMap'
  collection: ImportMaps
  fields:
    name:
      type: 'string'
      validator: Validators.required()
    fieldsArray:
      type: 'array'
      nested: 'ImportMapField'
      default: -> []
  indexes:
    name:
      fields:
        name:1
      options:
        unique:true
