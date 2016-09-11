theTemplate = Template.MapField
theTemplate.profiles [ 'CustomProps' ]

theTemplate.onCreated this:true, fn: ->

  @template.data.thingVar = @template.thingVar = new ReactiveVar

  # instead of accepting the field from the parent template as a data item
  # (which doesn't update when the parent changes after a save())
  # let's get the field *from* the parent via its *index*,
  # then, when the parent changes, we rerun this and get the new field instance
  # also handles the "add map field" by creating one when it can't be found
  @autorun =>
    parentThing = @data.parentThingVar.get()
    fieldsArray = parentThing.get 'fieldsArray'
    fieldThing  = fieldsArray?[@data?.index]
    unless fieldThing?
      fieldThing = new Meteor.$things.importMapField
      fieldThing._isUnsaved = true
    @template.thingVar.set fieldThing

theTemplate.helpers
  $options: this:true

  fieldVar: -> @template.thingVar

  visualIndex: -> if @data.index? then @data.index + 1

  changeButtonVisibility: ->
    if @template.deletingVar.get() then 'hidden'
    else if @data?.addingVar?.get?() or Nav.getParam('id')? then ''
    else 'invisible'

  cancelButtonVisibility: ->
    if @template.deletingVar.get()
      'confirm-delete-map-field-button'
    else if @data?.addingVar?.get?() or Nav.getParam('id')?
      'cancel-button'
    else 'invisible'

theTemplate.events
  $options: this:true

  'click .change-button, keypress input': ->
    if @event.type is 'keypress' and @event.keyCode isnt 13 then return
    @event.preventDefault()

    addition =
      foreignName     : $(@template.find '.map-field-foreign-name-input').val()
      localName       : $(@template.find '.map-field-local-name-input').val()
      localCollection : @template.thingVar.get().get 'localCollection'

    console.log 'save change...',addition

    if not addition.foreignName?.length > 0
      @template.errorVar.set 'Must provide an import column name'
      return

    if not addition.localName?.length > 0
      @template.errorVar.set 'Must provide a local name'
      return

    if not addition.localCollection?.length > 0
      @template.errorVar.set 'Must select a database name'
      return

    parentThing = @data.parentThingVar.get()
    fieldThing = @template.thingVar.get()

    # if the fieldThing already has the foreignName, then we're updating it
    # if the fieldThing isNew then just set it into it and add to parent

    console.log 'has things:',parentThing?,fieldThing?
    console.log 'parentThing:',parentThing
    console.log 'fieldThing:',fieldThing

    # nested array element class has _isNew = true even when it's *not* new
    # if fieldThing._isNew
    if fieldThing._isUnsaved
      console.log 'is new, pushing...',addition
      parentThing.push 'fieldsArray', addition
      console.log '  parentThing modifiers:',parentThing._getModifiers()
      console.log '  parentThing modified:',parentThing.getModified()
    else
      # it came from the parentThing, so, can we just update its values?
      console.log 'is NOT new, setting...'
      fieldThing.set addition
      # console.log '  parentThing modifiers:',parentThing._getModifiers()
      # console.log '  parentThing modified:',parentThing.getModified()

    console.log 'saving...',parentThing._getModifiers()
    console.log '  field:',fieldThing._getModifiers()
    Meteor.call 'saveThing', parentThing, (error, result) =>
      if error?
        parentThing.catchValidationException error
        console.log 'Error:',error
      else
        console.log 'successful... result:',result
        console.log '  parentThing modifiers:',parentThing._getModifiers()
        @template.editmode.set false
        Meteor.defer -> $('button.add-map-field').focus()

  'click .confirm-delete-map-field-button': ->
    parentThing = @data.parentThingVar.get()
    fieldThing = @data.field
    selector =
      foreignName: fieldThing.foreignName
      localName  : fieldThing.localName
      localCollection: fieldThing.localCollection

    console.log 'confirmed delete:'
    console.log '  parentThing:',parentThing
    console.log '  fieldThing:',fieldThing
    console.log '  selector:',selector

    removed = parentThing.pull 'fieldsArray', selector

    console.log '  parentThing modifiers',parentThing._getModifiers()

    if removed?.length is 1
      Meteor.call 'saveThing', parentThing, (error, result) =>
        if error?
          parentThing.catchValidationException error
        else
          @template.editmode.set false
          Meteor.defer -> $('button.add-map-field').focus()

  'click .cancel-delete-button': -> @template.deletingVar.set false


buttonTemplate = Template.AddMapField
buttonTemplate.profiles [ 'CustomPropsAdd' ]
