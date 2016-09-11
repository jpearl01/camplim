Template.profiles

  $options: this:true

  # FocusFirstInput: # create an onRendered action which does focus() on an input

  CosmosFormInput:

    onCreated:

      addIsAlwaysEditmode: ->
        editmode = @template.findKey 'editmode'
        if editmode?
          console.log 'editmode exists:',editmode
          if editmode?.get?
            @template.editmode = editmode
          else
            @template.editmode = get: (-> editmode), set: (->) # ignore

        else if Nav.paramEquals 'item', 'add'
          @template.editmode = get: (-> true), set: (->) # ignore

    helpers:

      useEditButtons: ->
        editmode = @template.editmode.get()
        useEditButtons = @template.findKey 'useEditButtons'

        # when editmode is true but item is 'view'
        return useEditButtons ? (editmode and Nav.paramEquals('item', 'view'))

      editmodeObject: -> @template.editmode

      editmode: ->
        unless @template.editmode?
          value = @template.findKey 'editmode', false
          # console.log 'editmode value:',value
          @template.editmode = if typeof(value) is 'object' then value else new ReactiveVar value
        @template.editmode.get()

      value: -> @findValue()

      formattedValue: (value) -> @formatValue (value ? @findValue())

      hasError: (name) ->
        name ?= @data.name
        thing = @findThing()
        if thing?
          error = thing.hasValidationError name
          return error

      error: (name) ->
        thing = @findThing()
        if thing?
          error = thing.getValidationError (name ? @data.name)
          return error

    events:

      'click .editmode-true': ->
        if @event.noEditmode then return
        @template.editmode.set true
        Meteor.defer =>
          target = @template.find '.focus-input'
          target?.focus?()
          target?.select?()

      'keyup .thing-input, click .cancel-button': ->
        if @event.type is 'keyup' and @event.which isnt 27 then return
        # console.log 'EVENT: Escape handler for CosmosFormInput'
        @event.preventDefault()
        @event.stopPropagation()
        original = @revertValue @findThing(), @data.name
        @template.editmode.set false
        # prevent the change event...
        $(@event.target).val original if original?

      'change .thing-input.CIE': ->
        console.log 'EVENT: CHANGE thing input CIE'

      'keyup .thing-input.KIE': ->
        if @event.type is 'keyup' and @event.keyCode is 27 then return

        # console.log 'EVENT: CosmosFormInput keyup .thing-input'#,@event.timeStamp

        unless @data.name?
          # console.log '  returning, no data.name'
          return

        input = $ @event.target
        value = input.val()
        thing = @findThing()
        # console.log 'isModified:',thing.isModified()

        if value is thing.get @data.name
          # console.log '  same value... returning',value,thing.get @data.name
          return

        # console.log '  setting:',@data.name,value
        thing.set @data.name, value

        if not @data.noClientValidate and not thing.validate @data.name
          # console.log '  didnt validate...stopping default and propagation'
          @event.preventDefault()
          @event.stopPropagation()
        return

      # this is only used in VIEW mode, so, do save without checking
      'click .change-button': ->
        # console.log 'CLICK CHANGE BUTTON'
        @event.preventDefault()
        target = $ @template.find '.text-input'
        value = target.val()
        thing = @findThing()
        # only set() if different because set()'ing the same value will
        # still cause isModified() to return true...
        if thing.get(@data.name) isnt value
          thing.set @data.name, value
        # else console.log '  values are the same, so, not set()\'ing'

        if thing.isModified()
          if @data.noClientValidate or thing.validate()
            # separate the if's so we can change editmode when not modified,
            # but not when invalid
            Meteor.call 'saveThing', thing, (error, result) =>
              if error?
                thing.catchValidationException error
              else
                @template.editmode.set false

        else # not modified
          @template.editmode.set false


    functions:

      # default just returns it
      formatValue: (value) -> value
      findValue: -> @findThing()?.get @data.name

      findThing: ->
        thingVar = @template.thingVar ? @template.findKey 'thingVar'
        thing = thingVar?.get?()
        return thing

      revertValue: (thing, name) ->
        # console.log 'revertValue name:',name
        originalValue = thing.getModified(true)?[name]
        # console.log '  original value:',originalValue
        if originalValue?
          currentValue = thing.get name
          # console.log "  for key[#{name}] value[#{currentValue}] original[#{originalValue}]"
          # if currentValue isnt originalValue then thing.set name, originalValue
          # if there's an original value then it was modified, so, revert:
          thing.set name, originalValue
        thing.clearValidationErrors()
        return originalValue


  CosmosForm:

    functions:

      $getLabel: (name) -> name[0].toUpperCase() + name[1...]

      revertValue: 'CosmosFormInput'
      findThing  : 'CosmosFormInput'

    helpers:

      thing: -> @template.thingVar.get()

    events:

    #   # moved to CosmosFormInput...
    #   # # on Escape revert to original (unsaved) value
    #   # 'keyup .thing-input': ->
    #   #   if @event.which is 27
    #   #     console.log 'Escape handler for CosmosForm'
    #   #     @event.preventDefault()
    #   #     thing = @template.thing
    #   #     name = $(@event.target).attr 'name'
    #   #     @revertValue thing, name
    #   #     return
    #
    #   # moved to CosmosFormInput...
    #   # if they change it, like selecting a new item,
    #   # or, if they type something on the keyboard,
    #   # or, if they Tab out or click away ...
    #   # removed `blur input` because after save() and Nav.to() it blurs and breaks
    #   # adding selectors so the event handlers can be disconnected by overriding inputSelector
    #   # 'change .thing-input.CIE, keyup .thing-input.KIE': ->
    #   #   if @event.keyCode is 27 then return
    #   #   console.log 'CHANGE / KEYUP + CIE/KIE'
    #   #   target = $(@event.target)
    #   #   key = target.attr 'name'
    #   #   value = target.val()
    #   #   thing = @template.thing
    #   #   thing.set key, value
    #   #   thing.validate()
    #   #   return
    #
      'submit form': ->
        console.log 'SUBMIT FORM: preventing default...'
        @event.preventDefault()

      # for Add forms the save button was a type 'submit' triggering `submit form`
      # so, need to add 'click .save-button' to this...
      'keyup .thing-input.KIE, click .save-button': (e,t) -> # the submit button clicked, or, Enter key pressed
        # apparently some browsers may not trigger a form submit when pressing Enter
        # so, let's watch for keypress in inputs as well and look for the Enter key...
        # but, for browsers where it works that means it'll submit twice?
        # or, will our preventDefault() take care of that?
        if @event.type is 'keyup' and (@data.noEnter or (@event.keyCode isnt 13)) then return

        console.log 'EVENT: KEYUP .thing-input.KIE (save button)'#,e.timeStamp

        @event.preventDefault()

        thing = @findThing()

        inputs = @template.$('input')
        inputs.each (index, input) =>
          input = $(input)
          name  = input.attr 'name'
          if name isnt @event.target.name
            value = input.val()
            if value? then thing.set name, value

        if thing.isModified()
          if @data.noClientValidate or thing.validate()
            Meteor.call 'saveThing', thing, (error, result) =>
              if error?
                thing.catchValidationException error
              else
                # find the template which has the `editmode` ReactiveVar on it
                view = Blaze.getView e.target
                view = Blaze.getView view while view?.name?[0...9] isnt 'Template.'
                template = view?.templateInstance?()
                template?.editmode?.set? false

              @formSave error, result

          # else
          #   console.log 'NOT VALID'
        else
          # console.log 'NOT MODIFIED',thing._getModifiers()
          # console.log '  hasChanges:',thing._hasChanges.get()
          # console.log '  name:',thing.get('name')
          template?.editmode?.set? false
