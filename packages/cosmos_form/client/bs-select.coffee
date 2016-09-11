theTemplate = Template.BootstrapFormSelect

theTemplate.profiles [ 'CosmosFormInput', 'BootstrapFormInput', 'CosmosSelectChoices' ]

theTemplate.events

  # Google Chrome is doing "Back Button" when typing Backspace while the Select
  # is focused... so, let's eat that event to prevent it.
  'keydown select': (event, template) ->
    if event.keyCode is 8
      event.preventDefault()
      console.log 'keydown select'

  'keyup select': (event, template) ->
    if event.keyCode is 8
      event.preventDefault()
      console.log 'keyup select'
