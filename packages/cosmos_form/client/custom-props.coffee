Template.profiles
  $options: this:true

  CustomProps:

    onCreated:
      addIsAlwaysEditmode: 'CosmosFormInput'
      addErrorAndDeletingVars: ->
        @template.errorVar = new ReactiveVar
        @template.deletingVar = new ReactiveVar
        if @data.addingVar? is true
          data = @data
          @template.editmode = get:(-> true), set: ((value) -> data.addingVar.set value)

    onRendered:
      focusFirstInput: ->
        if @data.addingVar?
          input = $ @template.find '.custom-input-key'
          Meteor.defer -> input.focus()

    helpers:

      groupClass: 'BootstrapFormInput'
      labelClass: 'BootstrapFormInput'
      fieldContainerClass: 'col-sm-8'
      # fieldClass: 'BootstrapFormInput'
      staticFieldClass: 'BootstrapFormInput'
      editIconClass: 'BootstrapFormInput'
      inputClass: 'BootstrapFormInput'
      inputSelector: 'BootstrapFormInput'
      errorClass: 'BootstrapFormInput'

      editmode: 'CosmosFormInput'
      useEditButtons: 'CosmosFormInput'
      hasError: -> @template.errorVar.get()?
      error: -> @template.errorVar.get()

      deleting: -> @template.deletingVar.get()

      # dont' use input names and stuff... we won't be using them like that...
      # make them *not* thing-input class, instead, custom-input class...
      # maybe custom-key-input and custom-value-input as well
      # customKeyName: -> @customName()
      # customValueName: -> @customName() +
      customKeyValue  : -> @data.key
      customValueType : -> @findThing().getCustomObject(@data.key)?.type ? 'text'
      customValueValue: ->
        valueObject = @findThing().getCustomObject @data.key
        if valueObject?.type is 'text' then valueObject.string
        else if valueObject?.type is 'date' then @formatDate valueObject.date, 'YYYY-MM-DD'

      formattedCustomValueValue: ->
        valueObject = @findThing().getCustomObject @data.key
        if valueObject?.type is 'text' then valueObject.string
        else if valueObject?.type is 'date' then @formatDate valueObject.date


      changeButtonVisibility: ->
        if @template.deletingVar.get() then 'hidden'
        else if @data?.addingVar?.get?() or Nav.paramEquals('item', 'view') then ''
        else 'invisible'

      cancelButtonVisibility: ->
        if @template.deletingVar.get()
          'confirm-delete-button'
        else if @data?.addingVar?.get?() or Nav.paramEquals('item', 'view')
          'cancel-button'
        else 'invisible'

      deleteButtonVisibility: ->
        if @data?.addingVar?.get?() then 'invisible'
        else if @template.deletingVar.get() then 'cancel-delete-button'
        else 'delete-button'

    functions:

      findThing: 'CosmosFormInput'
      revertValue: 'CosmosFormInput'
      formatDate: 'formatDate@MomentInput'
      parseDate: 'parseDate@MomentInput'

      customName: -> @findThing().getCustomNameFor @data.key

    events:

      'click .editmode-true': 'CosmosFormInput'

      'keyup input, click .cancel-button': ->
        if @event.type is 'keyup' and @event.keyCode isnt 27 then return
        # thing = @findThing()
        # if thing.isModified()
        #   name = @customName()
        #   if name?
        # we don't change the value as we're typing, right? only on Enter and change-button
        #@revertValue @findThing(), name
        @template.editmode.set false
        Meteor.defer =>
          @template.errorVar.set null
          @template.deletingVar.set false

      'keyup .custom-input-key': ->
        key = $(event.target).val()
        oldKey = @data.key
        if key isnt oldKey and @findThing().hasCustomKey(key)
          @template.errorVar.set 'The name is already in use.'
        else
          @template.errorVar.set null

      'click .change-button, keypress input': ->
        if @event.type is 'keypress' and @event.keyCode isnt 13 then return
        @event.preventDefault()
        keyInput = @template.find '.custom-input-key'

        unless keyInput?
          console.log 'returning... no custom key'
          return
        else keyInput = $ keyInput

        key = keyInput.val()

        if not key? or key is ''
          @template.errorVar.set 'Must provide a name'
          return

        oldKey = @data.key
        input = $(@template.find '.custom-input-value')
        value = input.val()
        if not value? or value.length is 0 then value = ' '
        if input.attr('type') is 'date' then value = @parseDate value, 'YYYY-MM-DD'
        # console.log "  oldKey = [#{oldKey}]  key = [#{key}]  value = [#{value}]"

        # tricky, if the `key` has changed, then we need to *delete* that one
        # otherwise, we can simply do a set() on that key with the new value

        thing = @findThing()

        if key isnt oldKey
          # we could be created a *new* key, or, erroneously dup'ing an existing key
          # if thing already has the custom key `key` then we *don't* allow it
          # otherwise, we delete `oldKey` and set `key`.
          if thing.hasCustomKey(key)
            # can't allow it. we're already displaying that key in another field...
            # how to add an error to thing for this current custom key?? bleh.
            # must have to track errors for custom key/value pairs locally.
            # TODO: set error locally to display
            @template.errorVar.set 'The name is already in use.'
            return
          else
            # if there was an old key, then, we must unset it
            if oldKey?.length > 0
              thing.unset thing.getCustomNameFor oldKey
            # set the new key/value
            thing.set thing.getCustomNameFor(key), value

        else # it's the same key, so, just set the new value, if it's different...?
          thing.set thing.getCustomNameFor(key), value

        # with the set/unset stuff done, do we save() ?
        # do we editmode=false ?

        # if there is a change-button to click, then, we're in a View with Editmode.
        # so, we should save it and editmode=false.

        # if it's an Enter press which caused this, well, that's tricker. if we're
        # in an Add form then we *don't* save(), but, if it's a View then we do save().
        # and, in an Add form our editemode should be immutable and not matter.
        # so, if in 'view' we save?

        onSuccess = =>
          @template.editmode.set false
          Meteor.defer -> $('button.add-custom').focus()

        if Nav.paramEquals 'item', 'view'
          Meteor.call 'saveThing', thing, (error, result) =>
            if error?
              thing.catchValidationException error
            else
              # @template.editmode.set false
              onSuccess()
        else
          # @template.editmode.set false
          onSuccess()

      'click .delete-button': ->
        # console.log 'clicked delete button'
        @template.deletingVar.set true

      'click .confirm-delete-button': ->
        # console.log 'clicked CONFIRM delete button'
        # if in VIEW mode we unset it and save()
        # if in ADD mode just unset it, no save()
        thing = @findThing()

        thing.unset thing.getCustomNameFor @data.key
        # no meteor call or concern for validation... just save it...
        # it will delete the property which causes this template to render, so,
        # it'll go away
        if Nav.paramEquals 'item', 'view' then thing.save()
        else @template.editmode.set false

      'click .cancel-delete-button': ->
        # console.log 'clicked CANCEL delete button'
        @template.deletingVar.set false


theTemplate = Template.BootstrapFormCustomInput

theTemplate.profiles [ 'CustomProps' ]



Template.profiles
  $options: this:true

  CustomPropsAdd:
    onCreated:
      addAddingVar: -> @template.addingVar = new ReactiveVar

    helpers:

      adding: -> @template.addingVar.get()
      addingVar: -> @template.addingVar

    events:

      'click .add-custom': ->
        @template.addingVar.set true
        Meteor.defer =>
          focusInput = @template.find '.focus-input'
          if focusInput? then $(focusInput).focus()


buttonTemplate = Template.BootstrapFormCustomAdd

buttonTemplate.profiles [ 'CustomPropsAdd' ]
