theTemplate = Template.ImportMaps

theTemplate.profiles [ 'CosmosForm' ] # not AVE

# theTemplate.names =
#   singular: 'importMap'
#   plural  : 'importMaps'
#   capital : 'ImportMap'


theTemplate.onCreated this:true, fn: ->
  @subscribe 'ImportMaps'

  @template.thingVar = new ReactiveVar
  errorVar = @template.errorVar = new ReactiveVar

  # map = name:null
  # @template.mapSelectorThingVar = new ReactiveVar
  #   get: (key) -> if key is 'mapName' then map.name else null
  #   set: (key, value) -> if key is 'mapName' then map.name = value
  #   hasValidationError: (key) -> if key is 'mapName' then errorVar.get()? else false
  #   getValidationError: (key) -> if key is 'mapName' then errorVar.get() else null

  # if there's an ID then we want to use autoselect the name of that map...
  @autorun =>
    id = Nav.getParam 'id'
    if id?
      @subscribe 'ImportMap', id
      importMap = ImportMaps.findOne _id:id
      if importMap?
        # map.name = importMap.get 'name'
        # @template.mapSelectorThingVar.dep.changed()
        @template.thingVar.set importMap

theTemplate.helpers
  $options: this:true

  thingVar: -> @template.thingVar

  # mapSelectorThingVar: -> @template.mapSelectorThingVar
  importMaps: -> ImportMaps.find {}, sort: name:1
  hasError: -> @template.errorVar.get()?
  error: -> @template.errorVar.get()
  # mapFields: ->
  #   # get fields names from thing (import map) and exclude '_id' and 'name'...
  #   thing = @findThing()
  #   array = thing.get 'fieldsArray'
  #   (value.foreignName for value,index in array)

# TODO: do this timeout stuff in form.coffee's keyup event handler
timeoutHandles = {}

theTemplate.events
  $options: this:true

  'change #importMapSelect': ->
    console.log 'change map select'
    select = $ @event.target
    mapId = select.val()
    console.log '  map id:',mapId
    # Nav.setParams combine:{params:true}, params: id:mapId
    Nav.setParams id:mapId

  # when they type something, verify the name isn't something already used...
  # delay a bit to allow them to type a group of letters first...
  'keyup #newImportMapName': ->
    console.log 'keyup for new name'
    # dont handle Enter, that's in the other one
    if @event.keyCode is 13 then return

    # use a timeout to add a small delay to accumulate letter presses
    # clear an old one...
    Meteor.clearTimeout timeoutHandles.nameCheck if timeoutHandles.nameCheck?
    # make a new one
    timeoutHandles.nameCheck = Meteor.setTimeout (=>
      console.log 'keyup new name timeout handler'
      # get the input value
      value = $(@event.target).val()

      # check if there's a map with the name already
      exists = ImportMaps.findOne(name:value)?

      # if it exists already, warn them
      if exists then @template.errorVar.set 'Name already used by an Import Map'
      else @template.errorVar.set null
    ), 300

  # when they click the button or press Enter...
  'click #newImportMapButton, keyup #newImportMapName': ->
    # only handle keyup for Enter
    if @event.type is 'keyup' and @event.keyCode isnt 13 then return
    console.log 'click/keyup new button'

    # TODO: disable button and ignore later Enter presses until we're done...

    # get name value
    input =
      if @event.type is 'keyup' then $(@event.target)
      else $('#newImportMapName')

    name = input.val()
    if name?.length > 0
      input.val ''

      # create the import map via a method
      Meteor.call 'createImportMap', name:name, (error, result) =>
        if error? then @template.errorVar.set error.reason
        else # it'll be added to the collection and showup in the select
          # so, set the `id` to cause it to become selected
          Nav.setParams id:result
