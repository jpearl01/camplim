# Template.profiles {this:true},
#
#   CamplimInputSubmitEvents:
#
#     events:
#
#       'change input': ->
#         # console.log 'change input'
#         valueString = @template.$getInputValue @event
#         # console.log 'valueString:',valueString
#         result = @template.$verifyString.call(this, valueString)
#         # console.log 'verifyString result:',result
#         @template.errorVar.set if 'string' is typeof(result) then result else null
#         return
#
#       # can't use keypress with Tab because it leaves the field.
#       # so, use keydown...
#       # keyup happens *after* it has moved to the next input field
#       # don't do this for now. we have to *not* do event.preventDefault() for this
#       # so the Tab will move to the next field. but, what if there's an error?
#       # then we want to stay within the field... so, later.
#       # 'keydown input': ->
#       #   console.log 'keyup input:',@event
#       #   if @template.$isTabKey @event then @template.$submitValue.call this
#       #   # TODO: also do string verification now that the key came up...
#       #   # perhaps after a small delay so we don't do it if they keep typing...
#       #   # make a timeout and then clear it when another keyup event happens...
#       #   # if @template.verifyStringTimeoutHandle?
#       #   #   Meteor.clearTimeout @template.verifyStringTimeoutHandle
#       #   #
#       #   # # TODO: use Blaze._withView (or whatever it's called...)
#       #   # @template.verifyStringTimeoutHandle = Meteor.setTimeout (->
#       #   #   console.log 'could verify string here...'
#       #   # ), 300
#
#       # can use keypress for Enter
#       'keypress input': ->
#         if @template.$isEnterKey @event then @template.$submitValue.call this
#
#   CamplimInput:
#
#     # all inputs have their own reactive var to hold the value retrieved
#     onCreated:
#       addVars: ->
#         #@template.valueVar = new ReactiveVar
#         @template.successVar = new ReactiveVar
#         @template.errorVar = new ReactiveVar
#
#       findStringVerifiers: ->
#         stringVerifiers = @template.findKey 'stringVerifiers'
#         # console.log 'found string verifiers:',stringVerifiers
#         if stringVerifiers?
#           # console.log 'now getting the one for this instance based on name:',@template.data.name
#           @template.stringVerifier = stringVerifiers[@template.data.name]
#           # console.log 'found? :',@template.stringVerifier
#         return
#
#     helpers:
#       value: ->
#         # console.log 'input profile value helper'
#         # try to get it from the input's reactive var
#         # value = @template.valueVar.get()
#
#         # get it from the collection
#         objectValue = @template.$getValue.call this
#
#         # console.log '  value:',value
#         # console.log '  objectValue:',objectValue
#
#         # if not there
#         # unless value is objectValue
#         #   # console.log '  they are different, formatting and setting...'
#         #   # format the value
#         #   value = @template.$formatValue.call this, objectValue
#
#         # format the value
#         valueString = @template.$formatValue.call this, objectValue
#
#         #
#         #   # set it into the value var for next time
#         #   # TODO: this is causing this helper to run a second time?
#         #   @template.valueVar.set value
#         @template.valueString = valueString
#
#         # return the value
#         # console.log '  the value found:',valueString #value
#         return valueString #value
#
#       hasSuccess: ->
#         result = @template.successVar.get()?
#         # console.log 'hasSuccess:',result
#         result
#
#       hasError: ->
#         result = @template.errorVar.get()?
#         # console.log 'hasError:',result
#         result
#
#       errorMessage: ->
#         result = @template.errorVar.get()
#         # console.log 'errorMessage:',result
#         result
#
#     # events:
#     #
#     #   # when pressing Escape reset the input's value to what's in the value var
#     #   'keydown input': ->
#     #     if @event.keyCode is 27
#     #       # console.log 'keydown[27] (Escape) input this:',this
#     #       $(@event.target).val(@template.valueVar.get()).change().blur()
#
#
#     functions:
#
#       $isEnterKey: (event) -> event.which is 13 or event.keyCode is 13
#       $isTabKey: (event) -> event.which is 9 or event.keyCode is 9
#
#       $isSubmitEvent: (event) ->
#         event.type is 'keypress' and (event.which is 13 or event.which is 9)
#
#       $getInputValue: (event) -> $(event.target).val() # currentTarget?
#
#       $verifyString: (valueString) ->
#
#         stringVerifier = @template.stringVerifier
#         # console.log 'stringVerifier:',stringVerifier
#         if stringVerifier?
#           result = stringVerifier.call this, valueString
#           # @template.errorVar.set if 'string' is typeof(result) then result else null
#           if 'string' is typeof(result)
#             @template.errorVar.set result
#             return false
#           else
#             @template.errorVar.set null
#
#         # else
#         #   console.log 'there is no verifier function ...'
#
#         # # default checks if it's required, if so, then there must be a value
#         # if @event
#         #   target = @template.find @event.target
#         #   console.log 'target:',target
#         #   console.log 'target.required:',target?.required
#         #   required = target.required#'required' is target?.attr?('required')
#         #   console.log 'there is an event so i can get the input, required:',target.required
#         #   if required and (not string? or string.length is 0)
#         #     console.log 'required but empty, setting error message...'
#         #     return 'Must provide a value for this field.'
#         #   else
#         #     console.log 'it is fine...'
#
#         return true
#
#       $parseValue: (string) ->
#         console.log '$parseValue (default):',string
#         string # default does nothing
#
#
#       $formatValue: (string) -> string # default does nothing
#
#       $verifyValue : (value) -> true # default does nothing
#
#       $subValue: subValue = (object, key) ->
#         keys = key.split '.'
#         value = object
#         value = value?[key] for key in keys
#         return value
#
#       $valueFor: valueFor = (object, key) ->
#         if object?
#           if object?[key]? then object[key]
#           else if key.indexOf '.' > -1
#             return subValue object, key
#
#       $getValue: ->
#         console.log '$getValue'
#         keys = [ 'object', 'value', 'name' ]
#         {object, value, name} = @template.findKeys keys
#         #if keys.length is 0 # then it found all the keys
#         # if it found object and either value or name then it's okay
#         result = valueFor object, (value ? name)
#         console.log '  result:',result
#         return result
#
#       $createUpdateSet: (name, value) ->
#         update = $set:{}
#         update.$set[name] = value
#         return update
#
#       $updateValue: (value, valueString) ->
#         valueString ?= value
#         console.log '$updateValue:',value
#         keys = [ 'collection', 'name', 'object' ]
#         {collection, name, object} = @template.findKeys keys
#         console.log '  keys:',keys
#         if keys.length is 0 or (keys.length is 1 and keys[0] is 'name')
#           # if `object` has an _id then do an update
#           # else, do an insert ?
#           update = @template.$createUpdateSet.call this, name, value
#           console.log '  update set:',update
#           # if it's exactly false then *don't* continue
#           if update is false
#             # need to show an error via errorVar ...
#             # change the check mark to an error X and set text-error (text-warning?)
#             # so they know it didn't go thru
#             return
#
#           unless object?._id?
#             console.log ' no object id... setting value into object'
#             object[key] = value for key,value of update.$set
#             console.log 'the object:',object
#             @template.$updateCallback.call this
#           else
#             # bind the callback to our `this`
#             callback = @template.$updateCallback.bind this
#             # console.log 'update object id:',object?._id
#             collection.update object?._id, update, (error, result) =>
#               if error? then return callback error
#               # @template.valueVar.set valueString
#               @template.valueString = valueString
#               callback error, result
#
#         return
#
#       $submitValue: ->
#         console.log 'input-profile $submitValue()'
#         @event.preventDefault()
#
#         # get the hopefully new value from the input
#         newValue = @template.$getInputValue @event
#
#         if newValue?.length is 0 then newValue = undefined
#
#         # get the old value from the reactive var (no need for get() dependency)
#         oldValue = @template.valueString # @template.valueVar.curValue
#
#         console.log '  newValue:',newValue
#         console.log '  oldValue:',oldValue
#
#         # verify the string value
#         if @template.$verifyString.call(this, newValue) isnt true then return
#
#         # if the values are the same then just return, we're done
#         if newValue is oldValue
#           console.log 'they are the same! quit.'
#           # console.log '  newValue:',newValue
#           # console.log '  oldValue:',oldValue
#           return
#
#         # parse string into an object, or differently formatted string
#         valueString = newValue
#         newValue = @template.$parseValue.call this, newValue
#         console.log '  newValue (parsed):',newValue
#         # verify again, but, this time as the parsed object/format
#         result = @template.$verifyValue.call this, newValue
#         console.log '  verifyValue:',result
#         # if `true` it's okay so continue, otherwise store the error and return
#         if result isnt true
#           @template.errorVar.set result
#           return
#         else @template.errorVar.set null
#
#         # finally, update the collection with the new value
#         @template.$updateValue.call this, newValue, valueString
#
#       $updateCallback: -> # default does nothing
#
#       $collection: -> @template.findKey 'collection'
