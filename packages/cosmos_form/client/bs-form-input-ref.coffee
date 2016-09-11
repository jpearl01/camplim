Template.profiles
  $options: this:true

  RefInput:

    # when we switch from static mode to edit mode init typeahead
    # defer it so it happens after the DOM is updated (the input is inserted)
    onRendered:

      setupTypeahead: ->
        @autorun =>
          if @template.editmode.get()
            Meteor.defer =>
              Meteor.typeahead @template.find('.typeahead')

    helpers:

      type: 'text'
      typeMarker: 'RI typeahead'
      inputSelector: 'RIE' # override so the change/keyup events don't write the value
      useChangeButton: false
      attributes: ->
        key = @template.findKey 'data-value-key'
        unless key?
          # thing = @findThing() #@getData(1)
          name = @data.name
          # field = thing.constructor.getBehavior('ref').definition.fields[name]
          field = @getRefField()
          key = field.to ? 'name'
        return it =
          autocomplete: 'off'
          spellcheck:   'off'
          'data-source': 'search'
          # this is in the collection's behavior-ref options as `to`
          'data-value-key': key # @template.findKey 'data-value-key', 'name'

      search: (query, _, callback) ->
        # console.log 'ref input search()'# this:',this
        # console.log '  query:',query

        searchOptions = @buildSearchOptions.call this
        if 'string' is typeof(searchOptions)
          # then it's an error...
          return

        searchName = searchOptions.name
        delete searchOptions.name

        # TODO: show an indicator we are waiting for results...

        Meteor.call searchName, query, searchOptions, (error, result) =>
          # TODO: hide wait indicator
          if error?
            console.log 'error searching:',error
          else
            callback? result
            return


    functions:

      getRefField: ->
        thing = @findThing() #@data.thing ? @getData(1)
        name = @data.name
        thing.constructor.schema.behaviors.ref.definition.fields[name]

      buildSearchOptions: ->
        options =
          fields: name:1
          sort  : ['name', 'asc']
          limit : 10

        keys = [ 'fields', 'sort', 'limit' ]
        @template.findKeys keys, options

        from = @getRefField()?.from
        options.name = from + '-search'

        return options

      autosave: ->
        result = Nav.paramEquals 'item', 'view'
        # console.log 'autosave:',result
        return result

      storeSuggestion: (suggestion) ->
        @event.preventDefault()

        thing = @findThing() #@data.thing ? @getData(1)
        field = @getRefField()
        idKey = field.id
        valueKey = field.to
        value = suggestion[valueKey]

        if thing.get(idKey) is suggestion._id and thing.get(@data.name) is suggestion[valueKey]
          @template.editmode.set false
          return

        set = {}
        set[idKey] = suggestion._id
        set[@data.name] = value
        thing.set set

      saveSuggestion: ->
        thing = @findThing()
        input = $(@event.target) #@template.find '.typeahead'
        Meteor.call 'saveThing', thing, (error, result) =>
          if error?
            thing.catchValidationException error
          else
            @template.editmode.set false

          input.typeahead 'close'


      showModal: ->
        field = @getRefField()
        name = field.name # 'project'
        input = $(event.target)
        modalName = name + 'Modal'
        context =
          inputName  : field.to ? 'name'
          value      : input.val()
          sourceThing: @findThing()
          sourceId   : field.id   # projectId
          sourceName : @data.name # projectName
          sourceInput: input
          sourceTemplate: @template
        # console.log '  context:',context
        Modal.show modalName, context

    events:

      'click .editmode-true': ->
        Meteor.setTimeout (=>
            target = @template.find '.tt-input'
            $(target).focus().focus()
          ), 10

      'keypress input': ->
        # remove autocompleted and selected because it has changed...
        # but, don't remove it if it's the Enter keypress...
        if @event.keyCode isnt 13
          # console.log 'keypress input isnt Enter so clearing selection flags'
          @template.autocompleted = false
          @template.selected = false
          return

        # Only need to open the modal if the value in the input isn't a search
        # result 'suggestion' which was selected...
        #
        # 1. search result selection: -> nada, it already stored it...
        #    this one turns editmode off which eliminates the input
        #    the input stays when in an Add form, so... look for selected
        # 2. search result autocompleted: -> need to store it...
        #
        # 3. non-search result value: -> open modal dialog

        @event.preventDefault()
        # console.log 'RefInput keypress ENTER'

        if @template.autocompleted
          # console.log '  autocompleted, so, already stored... saving'
          if @autosave() then @saveSuggestion()
          else $(@event.target).typeahead 'close'


        else if @template.selected
          # console.log '  already selected... '
          # if we're in 'add' mode then editmode doesn't change to false.
          # if we're in 'view' mode then we "should" have done editmode=false
          return

        else

          # if what's in there is the currently selected value then it will still
          # popup when hitting Enter.
          # if what they typed matches a result it'll still popup on Enter.
          # for them to select the search result they need to :
          # 1. press Tab then Enter for the first one, autocomplete
          # 2. down arrow to the one they want and then Enter
          # console.log 'calling showModal()'
          @showModal()

      'typeahead:autocompleted .RI': (event, template, suggestion, datasetName) ->
        # console.log 'autocompleted *event sug:',suggestion
        # template.suggestion = suggestion
        template.autocompleted = true
        @storeSuggestion suggestion
        # let the keypress input event handle store this if they hit Enter...

      'typeahead:selected .RI': (event, template, suggestion, datasetName) ->
        # console.log 'selected *event sug:',suggestion
        template.selected = true
        @storeSuggestion suggestion
        if @autosave() then @saveSuggestion()


theTemplate = Template.BootstrapFormInput.renderAs 'RefInput'

theTemplate.profiles [ 'CosmosFormInput', 'BootstrapFormInput', 'RefInput' ]
