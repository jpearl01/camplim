# create/update/delete an import/export maps

createEximMap = (collection) -> (map) ->
  check map, name:String
  console.log "create '#{collection._name}' map:",map
  return collection.insert name:map.name, creating:this.userId

updateEximMap = (collection) -> (id, fields) ->
  console.log "update '#{collection._name}' map:",id,fields
  if id? and fields?
    # TODO: assume they're done creating...
    return collection.update {_id:id}, $unset:{creating:null}, $set:{fields:fields}
  else
    throw new Meteor.Error 'Requires _id, name, and fields'

removeEximMap = (collection) -> (id) ->
  console.log "remove '#{collection._name}' map:",id
  collection.remove _id:id

startEximOp = (which) ->
  Class =
    if which is 'import' then ImportJob
    else if which is 'export' then ExportJob
    else throw new Meteor.Error 'Unknown EximOp type:',which

  return (op) ->
    # export only needs to specify the mapId, and optionally a file name
    # import must also specify a fileId of a file in EximFiles collection
    # op = _.pick op, [ 'mapId', 'fileId' ]
    #
    unless op.mapId? then throw new Meteor.Error 'Must specify a map ID'
    if which is 'import'
      unless op.fileId?
        throw new Meteor.Error 'Must specify a file for import'
      maps = ImportMaps
    else
      maps = ExportMaps

    eximOp =
      userId: this.userId
      type: which
      status: 'queued' # processing, completed, errored
      created: new Date()
      mapId: op.mapId
      mapName: maps.findOne(_id:op.fileId)?.name

    # must be an export
    if op.fileId?
      eximOp.fileId   = op.fileId
      eximOp.fileName = EximFiles.findOne(_id:op.fileId)?.name
    else if op.fileName? then eximOp.fileName = op.fileName
    #  TODO: generate a file id for the export file: op.fileName

    # 1. store into our collection so we can remember what happened (meteor-workers removes completed jobs...?)
    eximOp.opId = EximOps.insert eximOp

    # 2. create the job object
    eximJob = new Class eximOp

    # 3. add the job to the meteor-workers thing
    Job.push eximJob


Meteor.methods

  # could ask them for a map name upfront when they want to create a new one.
  # then, save the map with the name only and a creating:true marker so it
  # isn't displayed in the select an import map view.
  # then, we can bring them to a page to view the individual map to edit it.
  # then, there's only one view and there isn't an "add" mode, only "view/edit"

  createImportMap: createEximMap ImportMaps
  createExportMap: createEximMap ExportMaps

  updateImportMap: updateEximMap ImportMaps
  updateExportMap: updateEximMap ExportMaps

  removeImportMap: removeEximMap ImportMaps
  removeExportMap: removeEximMap ExportMaps

  startImportOp: startEximOp 'import'

  removeEximOp: (id) -> EximOps.remove _id:id
