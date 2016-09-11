#
# theTemplate = Template.BootstrapInput.renderAs 'DateInput'
#
# theTemplate.profiles [ 'CamplimInput', 'CamplimInputSubmitEvents', 'BootstrapInput', 'MomentInput' ]
#
# theTemplate.helpers
#
#   type: -> 'date'
#   typeMarker: -> 'DI'
#
# theTemplate.functions {this:true},
#
#   $parseValue: (string) -> if string? then @template.$parseDate string, 'YYYY-MM-DD'
#
#   $formatValue: (date) -> if date? then @template.$formatDate date, 'YYYY-MM-DD'
