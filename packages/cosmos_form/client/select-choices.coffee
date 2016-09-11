Template.profiles
  $options: this:true

  CosmosSelectChoices:

    helpers:

      value: ->
        value = @findValue() #'CosmosFormInput' #
        console.log 'buttons value:',value
        return value

      choices: -> @findThing().constructor.getValidator(@data.name).param

      isChoice: (choice) -> choice is @findValue() #@findThing().get(@data.name)

    events:

      # TODO: how to get an "Escape" keypress event on a select ?

      'click a': ->
        @event.preventDefault()
        value = $(@event.target).text()
        thing = @findThing()
        name = @data.name
        @storeValue value
        unless @data.autosave
        # unless (@data.autosave or thing._isNew)
          button = $ @template.find 'button.button-choices'
          # ensure the button's text is changed to the value...
          # for some reason, it doesn't sometimes.
          Meteor.defer ->
            text = button.text()
            if text isnt value then button.text value
            button.html value + ' <span class="caret"></span>'

      'change select': ->
        @storeValue $(@event.target).val()

    functions:

      findThing: 'CosmosFormInput'
      findValue: 'CosmosFormInput'

      storeValue: (value) ->
        thing = @findThing()
        name = @data.name
        editmode = @template.findKey 'editmode'
        editmode ?= @template.editmode
        if thing.get(name) isnt value
          thing.set name, value
          if @template.findKey('autosave', Nav.paramEquals('item', 'view'))
            Meteor.call 'saveThing', thing, (error, result) ->
              if error?
                thing.catchValidationException error
              else
                editmode?.set false
        else
          editmode?.set false
        return


Template.SelectChoices.profiles [ 'CosmosSelectChoices' ]
Template.ButtonChoices.profiles [ 'CosmosSelectChoices' ]
