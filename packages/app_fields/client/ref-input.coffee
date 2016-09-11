#
# Template.profiles {this:true},
#
#   RefInput:
#     helpers:
#       typeMarker: -> 'RF typeahead'
#
#       name: ->
#         keys = [ 'name', 'suffix']
#         {name, suffix} = @template.findKeys keys, suffix:'Name'
#         name + suffix
#
#       attributes: ->
#         autocomplete: 'off'
#         spellcheck:   'off'
#         'data-source': 'search'
#         'data-value-key': @template.findKey 'data-value-key', 'name'
#
#       search: (query, _, callback) ->
#         console.log 'ref input search()'# this:',this
#         console.log '  query:',query
#
#         searchOptions = @template.$buildSearchOptions.call this
#         searchName = searchOptions.name
#         delete searchOptions.name
#         console.log 'searchName:',searchName
#
#         Meteor.call searchName, query, searchOptions, (error, result) ->
#           if error?
#             console.log 'error searching:',error
#           else
#             console.log result
#             callback? result
#             return
#
#     functions:
#
#       $buildSearchOptions: ->
#         options =
#           fields: name:1
#           sort  : ['name', 'asc']
#           limit : 10
#
#         keys = [ 'ref', 'fields', 'sort', 'limit' ]
#         @template.findKeys keys, options
#
#         if keys.length > 1 and keys[0] is 'ref'
#           # then we can't continue, we need the `ref`
#           return 'Error, unable to find `ref`'
#
#         options.name = options.ref + '-search'
#         delete options.ref
#
#         return options
#
#       $getValue: ->
#         keys = [ 'object', 'value', 'name', 'suffix' ]
#         {object, value, name, suffix} = @template.findKeys keys, suffix:'Name'
#
#         # console.log '$getValue'
#         # console.log '  object:',object
#         # console.log '  value:',value
#         # console.log '  name:',name
#         # console.log '  suffix:',suffix
#         # console.log '  key:',(value ? name + suffix)
#
#         # if it found object and either value or name then it's okay
#         result = @template.$valueFor object, (value ? name + suffix)
#
#         # console.log '  valueFor:',result
#         # console.log ' '
#
#         return result
#
#       $formatValue: (value) ->
#         console.log 'RefInput $formatValue :',value
#         value
#       #$parseValue: (string) -> # put back into object? what about name?
#
#       # $getInputValue: (event) ->
#       #   # can we ask the select what its selected value is??
#       #   # if we can, then we can get the selection, which may be no selection,
#       #   # and build the value as an object ... still, the default stuff is going
#       #   # to push what we provide into the property name 'loggedByName' ...
#       #   # we want to push an update containing three values: id, name, from.
#       #   # getInputValue can still provide the name back and do its thing
#       #   $(event.target).val() # currentTarget?
#
#       # so, maybe we can make $parseValue do what we want? it's going to give us
#       # the name as a string. we can return an object, but, once again, it'll try
#       # and put that in as the name 'loggedByName' instead of as we do it.
#       #
#       # can we make a createUpdateSet function so we can override that?
#       $createUpdateSet: (name, value) ->
#         # update = $set:{}
#         # update.$set[name] = value
#         # return update
#
#         keys = [ 'ref', 'suffix']
#         {ref, suffix} = @template.findKeys keys, suffix:'Name'
#         target = $(@event.target)
#         name = target.attr 'id'
#         console.log '  ref:',ref
#         console.log '  suffix:',suffix
#         console.log '  name:',name
#
#         update = $set:{}
#
#         if @template.suggestion
#           console.log 'suggestion!'
#           update.$set[name + 'Id']   = @template.suggestion._id
#           update.$set[name + suffix] = @template.suggestion.name
#           @template.suggestion = null
#         else
#           console.log 'no suggestion...'
#           # # here we are once again in a sync function and we need to do the async
#           # # operation of inserting a new thing into the other collection
#           # # *and*, for Members, we should *not* allow them to make new members...
#           # # right??
#           # # do the error and red X i mentioned in the comments in submitValue ...?
#           # # or, just create a new one....
#           #
#           # # for now, just create it...
#           # collection = Meteor.$db[ref]
#           # if collection?
#           #   name = target.val()
#           #   console.log 'target.val():',name
#           #   if name?.length > 0
#           #     currentView = Blaze.currentView
#           #     collection.insert name:name, (error, docId) =>
#           #       if error? then return console.log "Error inserting into #{ref} with name #{name}"
#           #       # now we have the id... just need to update the document with it...
#           #       Blaze._withCurrentView currentView, =>
#           #         @template.suggestion = _id:docId, name:name
#           #         @template.$updateValue.call this, name
#           #
#           # console.log 'leaving $createUpdateSet cuz of no suggestion and a pending insert'
#           # return false
#
#           # put the name in there without an ID. the before.update/insert will
#           # do an insert for us and then add the id.
#           console.log 'are these the same??'
#           console.log '  target.val():',target.val()
#           console.log '  value:',value
#           update.$set[name + suffix] = target.val()
#
#
#         update.$set[name + 'From'] = ref
#
#         console.log '  update:',update
#
#         console.log '  closing select dropdown cuz we made it this far...'
#         # console.log '  find:',@template.$('.typeahead') # use .BI.RF ?
#         @template.$('.typeahead').typeahead 'close'
#         return update
#
#     events:
#
#       # submit value on Enter key, not the keydown for Tab...
#       CamplimInputSubmitEvents: 'keypress input'
#
#       'typeahead:open .RF': (event, template) ->
#         console.log 'opened *event'
#
#       'typeahead:close .RF': (event, template) ->
#         console.log 'closed *event'
#
#       # this is when the user presses 'Tab' and it selects the first result and fills in
#       # after they Tab again they'll leave the input without a selected event.
#       # 'typeahead:autocomplete .RF': (event, template, suggestion, datasetName) ->
#       #   console.log 'AUTOCOMPLETE *event sug:',suggestion
#
#       'typeahead:autocompleted .RF': (event, template, suggestion, datasetName) ->
#         console.log 'autocompleted *event sug:',suggestion
#         template.suggestion = suggestion
#         template.autocompleted = true
#         # template.$submitValue.call this
#         # template.suggestion = null
#         # template.autocompleted = false
#
#       # this is when the user clicks on a selection,
#       # or,
#       # arrows to a selection and presses Enter or Tab
#       # 'typeahead:select .RF': (event, template, suggestion, datasetName) ->
#       #   console.log 'SELECT!'
#
#       'typeahead:selected .RF': (event, template, suggestion, datasetName) ->
#         console.log 'selected *event'
#         console.log '  suggestion = ',suggestion
#         console.log '  datasetName = ',datasetName
#         console.log '  this:',this
#         template.suggestion = suggestion
#         template.selected = true
#         template.$submitValue.call this
#         template.suggestion = null
#         template.selected = false
#
#
# theTemplate = Template.BootstrapInput.renderAs 'RefInput'
#
# theTemplate.profiles [ 'CamplimInput', 'BootstrapInput', 'RefInput' ]
#
# theTemplate.onRendered -> Meteor.typeahead.inject()
