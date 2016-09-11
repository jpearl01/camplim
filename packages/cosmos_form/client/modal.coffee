Template.profiles
  $options: this:true

  ModalBox:

    helpers:

      # default to our templates
      modalHeader: -> @data?.modalHeader ? 'ModalHeader'
      modalFooter: -> @data?.modalFooter ? 'ModalFooter'

      # default to the parent's data
      modalHeaderData: -> @data ? @getData(1)
      modalBodyData  : -> @data ? @getData(1)
      modalFooterData: -> @data ? @getData(1)

      modalDialogClass: 'modal-lg'

    functions:

      getThing: ->
        @template.modalThing ?= @newThing()
        return @template.modalThing

    # this is for the ModalBody, but, we'll do it in ModalBox so it's after it's all rendered...
    onRendered:

      focusFirstInput: ->
        # console.log 'on rendered focus on first input'
        Meteor.setTimeout (=>
          # TODO: could search for inputs and use the first one...
          inputName = @data.inputName ? 'name'
          input = $ @template.find "input[name=#{inputName}]"
          unless input? then input = $ @template.find 'input'
          if input?
            if @data.value?.length > 0
              thing = @getThing()
              if thing? then thing.set inputName, @data.value
              input.val(@data.value)
              # input.change() # change() no longer works. dropped the event.
              input.select()
            input.focus().focus()
        ), 500


    events:
      'change .thing-input': ->
        input = $(@event.target)
        name  = input.attr 'name'
        value = input.val()
        thing = @getThing()
        thing.set name, value

      'keypress .thing-input, click .add-button': ->
        if @event.type is 'keypress'
          # if it's not Enter then return
          if @event.keyCode isnt 13 then return
          # ensure the input we're in has been stored into the thing
          else
            input = $(@event.target)
            input.change()
            # name  = input.attr 'name'
            # value = input.val()
            # thing = @getThing()
            # thing.set name, value

        @event.preventDefault()
        @event.stopPropagation()

        thing = @getThing()

        unless thing?.isModified() then return

        # search for the data... different when doing Enter and clicking the button
        if @data.parentData? then data = @data.parentData
        else if @template.data?.inputName? then data = @template.data
        else if @data.inputName? then data = @data
        else return

        Meteor.call 'saveThing', thing, (error, result) =>
          if error?
            console.log 'Error saving',error
            thing.catchValidationException error
            return

          sourceThing = data.sourceThing
          set = {}
          set[data.sourceId] = result#._id #thing._id
          value = set[data.sourceName] = thing.get data.inputName
          sourceThing.set set

          # i need the input in the *other* form to do val(value) to...
          input = data.sourceInput
          if input?
            # if it's a typeahead select then don't use val()...
            if data.sourceInput.hasClass 'typeahead'
              data.sourceInput.typeahead 'val', value
            else
              input.val value
              input.change()

          if Nav.paramEquals 'item', 'view'
            # console.log '  in view mode'
            Meteor.call 'saveThing', sourceThing, (error, result) =>
              if error?
                console.log 'Error saving:',error
                sourceThing.catchValidationException error
              else
                data.sourceTemplate.editmode.set false
          # else if Nav.paramEquals 'item', 'add'
          #   # trigger a changed event..., or, will .val() do that??
          #   console.log '  in add mode'

          Meteor.setTimeout (->
            data.sourceInput.focus()
          ), 500
          Modal.hide()


  ModalHeader:

    helpers:

      headerTitle: -> @data.headerTitle ? ''

  ModalFooter:

    helpers:

      cancelLabel: -> @data.cancelLabel ? 'Cancel'
      cancelClass: -> @data.cancelClass ? 'cancel-button'
      # cancelIndex: -> @data.cancelIndex ? '31'
      addLabel: -> @data.addLabel ? 'Add'
      addClass: -> @data.addClass ? 'add-button'
      # addIndex: -> @data.addIndex ? '32'


Template.ModalBox.profiles [ 'ModalBox' ]
Template.ModalHeader.profiles [ 'ModalHeader' ]
Template.ModalFooter.profiles [ 'ModalFooter' ]
