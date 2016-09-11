fs = Npm.require 'fs'
corepath = Npm.require 'path'
eachLine = Npm.require 'each-part'
thru = Npm.require 'through2'

class @ImportJob extends Job

  buildImporter: (importMap) ->
    # console.log 'buildImporter importMap:',importMap
    fields = importMap.fieldsArray.slice()
    once = false
    thru.obj Meteor.bindEnvironment (values, _, next) ->
      # console.log 'importer'
      # console.log 'importer values:',values
      # Meteor.setTimeout next, 1

      # values[key] :> key is column header, should match `foreignName`
      # the value is what we put into `localName` of `localCollection`

      # so, iterate fieldsArray
      # for each foreignName, check if there is a non-empty value in `values`
      # if yes, store the value into an object for inserting
      # store them by localCollection name so they get grouped

      # then, iterate inserts and use collection name to get the collection
      # then, search the collection for an object with its values
      # if not found, then perform the insert.
      # when all inserts are done, do next()

      unless once
        once = true
        data = {}

        console.log 'importer',Meteor.userId(),Meteor.user()?.profile?.name

        for field in fields
          if values[field.foreignName]?.length > 0
            # TODO: could put a function on the collection which we use here...
            # OR, build up the values in an object and then give them to a function on the collection
            fieldData = data[field.localCollection] ?= {}
            fieldData[field.localName] = values[field.foreignName]

        # console.log 'importer data:',data

        for collectionName,fieldData of data when collectionName is 'specimens'
          console.log 'import for:',collectionName
          collection = Meteor.$db[collectionName]
          unless collection? then continue

          if collection.find(fieldData).count() > 0 then continue

          if collection.import?
            console.log 'import() style'
            collection.import data #fieldData

          else if collection.Thing?
            console.log 'thing style...'
            thing = new collection.Thing
            console.log '  created thing'
            thing.set fieldData
            console.log '  set values into thing'
            # search using converted values provided by Thing operations
            selector =
              if fieldData._id? then _id:fieldData._id
              else thing._getModifiers()?.$set
            console.log '  selector:',selector
            if Object.keys(selector).length > 0 and collection.find(selector).count() > 0
              continue
            console.log 'thing, pre-save:'
            console.log '  mods:',thing._getModifiers()
            thing.save()
            # Meteor.call 'saveThing', thing, false, (error, result) ->
            #   if error?
            #     console.log 'Error:',error
            #   else
            #     ; # blah

          else collection.insert fieldData

      next()

  columnValues: ->
    opId = @params.opId
    columnHeaders = null
    thru.obj Meteor.bindEnvironment (line, _, next) ->

      # TODO: configure this delimiter in the OP...
      strings = line.string.split '\t'

      # first line is headers
      unless columnHeaders?
        columnHeaders = {}
        columnHeaders[header] = index for header,index in strings
        # console.log 'headers:',JSON.stringify columnHeaders, null, 2
        next()
      else
        values = {}
        values[header] = strings[index] for header,index of columnHeaders
        next null, values

  countLines: ->
    opId = @params.opId
    futureUpdate = null
    lineCount = 0
    thru.obj Meteor.bindEnvironment (line, _, next) ->
      lineCount++
      unless futureUpdate?
        futureUpdate = Meteor.setTimeout (->
          futureUpdate = null
          EximOps.update {_id:opId}, $set:lines:lineCount
        ), 1000

      next null, line

  progressUpdater: (size) ->
    opId = @params.opId
    byteCount = 0
    progress = 0
    futureUpdate = null
    thru Meteor.bindEnvironment (bytes, enc, next) ->
      console.log 'progress updater...',byteCount
      byteCount += bytes.length
      progress = Math.round (byteCount / size) * 100

      unless futureUpdate?
        # schedule it in a second..
        futureUpdate = Meteor.setTimeout (->
          futureUpdate = null
          EximOps.update {_id:opId}, $set: progress:progress
        ), 1000

      next null, bytes.toString 'utf8'

  beforeJob: ->
    EximOps.update {_id:@params.opId}, $set:
      status:'processing', progress:0, lines:0, started:new Date

    # console.log 'beforeJob: is setUserId available?',this?.setUserId?
    # @setUserId @params.userId

  afterJob: (error) ->
    if error?
      console.log 'Error:',error
      errorMessage = error.reason
      if not errorMessage? and error.message? then errorMessage = error.message[1...-1]
      if not errorMessage? then errorMessage = error.toString()
      set = $set: status:'errored', error:(error.reason ? error.toString()), errored:new Date
    else
      set = $set: status:'completed', completed:new Date

    EximOps.update {_id:@params.opId}, set

    # @setUserId null

  handleJob: (done) ->
    console.log 'import job'
    # console.log '  params:',@params

    importMap = ImportMaps.findOne _id:@params.mapId
    # console.log '  importMap:',importMap

    unless importMap? then throw new Meteor.Error 'No import map specified'

    # get the import file info
    fileInfo = EximFiles.findOne _id:@params.fileId
    # console.log '  fileInfo:',fileInfo

    unless fileInfo?.path? then throw new Meteor.Error 'No import file specified'

    # get the import file as a stream
    # console.log '  read stream for:',fileInfo.path
    fileStream = fs.createReadStream fileInfo.path

    # 3. provide import map transform which accepts object of line values by name and
    #    produces object(s) for insert into collections.
    #    NOTE: be careful to avoid inserting duplicates...
    #    use the map's `fields` to map from column name to the collection and
    #    field name. build insert objects by collection name (in inserts object)
    #    then, insert them all when done.

    # get the import map
    importer = @buildImporter importMap

    userId = @params.userId
    importer.on 'finish', Meteor.bindEnvironment ->
      console.log 'importer.on finish'
      # mark the file as imported and by who
      fileInfo.importedById = userId
      fileInfo.importedDate = new Date()

      EximFiles.update {_id:fileInfo._id}, fileInfo

      done undefined, true

    importer.on 'error', Meteor.bindEnvironment (error) ->
      console.log 'Error importing:',error
      done error

    # fileStream.pipe @smallChunks()
    fileStream.pipe @progressUpdater(fileInfo.size)
              .pipe eachLine()
              .pipe @countLines()
              .pipe @columnValues()
              .pipe importer
