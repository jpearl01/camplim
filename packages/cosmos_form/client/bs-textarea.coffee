theTemplate = Template.BootstrapFormTextArea

theTemplate.profiles [ 'CosmosFormInput', 'BootstrapFormInput' ]

theTemplate.helpers
  $options: this:true

  rows: Template.$makeHelper 'rows', 5

  formattedValue: ->
    value = @findValue()
    if value?.length > 0
      value = Spacebars.SafeString value.replace /\n/g, '<br/>'
    return value

# theTemplate.functions
#   $options: this:true
#
