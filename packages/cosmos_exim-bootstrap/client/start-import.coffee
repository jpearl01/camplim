theTemplate = Template.ImportStart

theTemplate.onCreated this:true, fn: ->
  console.log 'subscribing ...'
  @subscribe 'ImportMaps'
  @subscribe 'ImportFiles'
  @template.selections = {}
  @template.disableButtonState = new ReactiveVar true


theTemplate.helpers
  $options: this:true

  disableStartButton: ->
    # state = @template.disableButtonState.get()
    # unless state.hasFile and state.hasMap then 'disabled'
    if @template.disableButtonState.get() then 'disabled'

  importFiles: ->
    console.log 'import files...'
    EximFiles.find {type:'import'}, sort: name:1

  importMaps: ->
    console.log 'import maps...'
    ImportMaps.find {}, sort: name:1


theTemplate.events
  $options: this:true

  'change #importFileSelect, change #importMapSelect': ->
    # get our input element
    select = $(@event.target)

    # get the selection's id (the option value)
    id = select.val()

    # if the `id` isnt a non-empty string then set it to null
    unless id?.length > 0 then id = null

    # which one is it? importMapSelect or importFileSelect
    which = select.attr 'id'

    # store the value into our selections (or nullify...)
    @template.selections[which] = id

    # what would the disabled button's new state be based on the values?
    newState = not (@template.selections.importMapSelect? and @template.selections.importFileSelect?)

    # what's the current state
    disableButtonState = @template.disableButtonState.get()

    # if the state is changed, then set the new value in there
    if newState isnt disableButtonState
      @template.disableButtonState.set newState

    console.log 'import selections:',@template.selections

  'click .start-button': ->
    unless @template.disableButtonState.curValue
      Meteor.call 'startImportOp', {
        mapId : @template.selections.importMapSelect
        fileId: @template.selections.importFileSelect
      }, (error, result) =>
        if error?
          console.log 'Error starting import:',error
        else
          Notify.success 'Import started'
          @template.selections = {}
          @template.disableButtonState.set true
          # Nav.to ... `result` is the ID of the EximOp to watch...
