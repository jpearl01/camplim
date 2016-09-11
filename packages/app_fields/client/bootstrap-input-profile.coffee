# Template.profiles {this:true},
#
#   BootstrapFormInput:
#
#     helpers:
#
#       # true by default
#       editmode: -> true
#
#       # can do a default value which capitalizes the name property
#       label: Template.$makeHelper 'label'
#
#       type: Template.$makeHelper 'type', 'text'
#
#       groupClass: Template.$makeHelper 'groupClass', 'form-group', 3
#
#       labelClass: Template.$makeHelper 'labelClass', 'control-label col-sm-2'
#
#       # fieldDivClass: Template.$makeHelper 'fieldDivClass', 'col-sm-8'
#
#       fieldContainerClass: Template.$makeHelper 'fieldContainerClass', 'col-sm-9'
#
#       fieldClass: Template.$makeHelper 'fieldClass'
#
#       inputClass: Template.$makeHelper 'inputClass', 'form-control'
#
#       useAddonSuffix: Template.$makeHelper 'useAddonSuffix', true # false
#
#       addonClass: Template.$makeHelper 'addonClass', 'input-group-addon'
#
#       addonSuffixContent: Template.$makeHelper 'addonSuffix', 'suffix'
#
#       useFeedback: Template.$makeHelper 'useFeedback', true
#
#       feedbackClass: Template.$makeHelper 'feedbackClass', 'form-control-feedback glyphicon'
#
#       errorClass: Template.$makeHelper 'errorClass', 'has-error col-sm-9 col-sm-offset-2'
#
#       # groupStatusClass: ->
#       #   if @template.errorVar.get()? then 'has-error has-feedback'
#       #   else if @template.successVar.get() then 'has-success has-feedback'
#       #   else ''
#       #
#       # feedbackIcon: ->
#       #   if @template.errorVar.get()? then 'glyphicon-remove'
#       #   else if @template.successVar.get() then 'glyphicon-ok'
#       #   else ''
#
#
#   BootstrapInput:
#
#     functions:
#
#       # shows the update thing at the end of the input (a check mark)
#       $updateCallback: (error, result) ->
#         if error?
#           # TODO: user friendly error displayed...
#           # TODO: change the check icon to an X icon with color red.
#           #       add a tooltip to it with error info
#           console.log 'error updating value:',error
#         else
#           console.log 'value update successful'
#           # console.log 'update callback event:',@event
#           successVar = @template.successVar
#           successVar.set true
#           Meteor.setTimeout (-> successVar.set null), 5000
#
#
#     helpers:
#
#       # use ID or NAME
#       id: ->
#         keys = [ 'id', 'name' ]
#         {id, name} = @template.findKeys keys, null, 3
#         if id? and typeof(id) isnt 'function' then id else name
#
#       name: Template.$makeHelper 'name'
#
#       # can do a default value which capitalizes the name property
#       label: Template.$makeHelper 'label'
#
#       type: Template.$makeHelper 'type', 'text'
#
#       groupClass: Template.$makeHelper 'groupClass', 'form-group', 3
#
#       groupStatusClass: ->
#         if @template.errorVar.get()? then 'has-error has-feedback'
#         else if @template.successVar.get() then 'has-success has-feedback'
#         else ''
#
#
#       labelClass: Template.$makeHelper 'labelClass', 'control-label col-sm-2'
#
#       # fieldDivClass: Template.$makeHelper 'fieldDivClass', 'col-sm-8'
#
#       fieldContainerClass: Template.$makeHelper 'fieldContainerClass', 'col-sm-9'
#
#       fieldClass: Template.$makeHelper 'fieldClass'
#
#       inputClass: Template.$makeHelper 'inputClass', 'form-control'
#
#       useAddonSuffix: Template.$makeHelper 'useAddonSuffix', true # false
#
#       addonClass: Template.$makeHelper 'addonClass', 'input-group-addon'
#
#       addonSuffixContent: Template.$makeHelper 'addonSuffix', 'suffix'
#
#       useFeedback: Template.$makeHelper 'useFeedback', true
#
#       feedbackClass: Template.$makeHelper 'feedbackClass', 'form-control-feedback glyphicon'
#
#       feedbackIcon: ->
#         if @template.errorVar.get()? then 'glyphicon-remove'
#         else if @template.successVar.get() then 'glyphicon-ok'
#         else ''
#
#       errorClass: Template.$makeHelper 'errorClass', 'has-error col-sm-9 col-sm-offset-2'
#
#       updateId: (directValue) ->
#         updateId = @template.findKey 'updateId', null, null, directValue
#         unless updateId? then updateId = @template.findKey('name')
#         unless updateId? then console.log 'Error, unable to find `updateId` or `name` to build it'
#         updateId +=  '-input-udpate'
#         @template.__updateId = updateId
#         return updateId
#
#       placeholder: Template.$makeHelper 'placeholder'
#
#       minlength: Template.$makeHelper 'minlength'
#
#       maxlength: Template.$makeHelper 'maxlength'
#
#       required: Template.$makeHelper 'required', 'required' # fields are required unless specified
#
#       readonly: Template.$makeHelper 'readonly'
#
#       attributes: -> # don't search up hierarchy, must be on parent template
#         attrs = @getData()?.attributes
#         #console.log 'attrs:',attrs
#         return attrs
