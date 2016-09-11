formatter = (defaultFormat) -> (datetime, format) ->
  unless 'string' is typeof(format) then format = null
  if datetime? then moment(datetime).format(format ? defaultFormat)

parser = (defaultFormat) -> (datetime, format) ->
  unless 'string' is typeof(format) then format = null
  if datetime? then moment(datetime, (format ? defaultFormat)).toDate()

formatDateWithMoment     = formatter 'MM/DD/YYYY'
formatDateTimeWithMoment = formatter 'MM/DD/YYYY hh:mm A'
formatTimeWithMoment     = formatter 'hh:mm A'

parseDateWithMoment     = parser 'YYYY-MM-DD'
parseDateTimeWithMoment = parser 'YYYY-MM-DDTHH:mm'
parseTimeWithMoment     = parser 'HH:mm'

Template.registerHelper 'formatDate', formatDateWithMoment
Template.registerHelper 'formatDateTime', formatDateTimeWithMoment
Template.registerHelper 'formatTime', formatTimeWithMoment

Template.registerHelper 'parseDate', parseDateWithMoment
Template.registerHelper 'parseDateTime', parseDateTimeWithMoment
Template.registerHelper 'parseTime', parseTimeWithMoment

Template.profiles

  $options: this:true

  MomentInput:

    functions:

      formatDate: formatDateWithMoment
      parseDate: parseDateWithMoment

      formatDateTime: formatDateTimeWithMoment
      parseDateTime: parseDateTimeWithMoment

      formatTime: formatTimeWithMoment
      parseTime: parseTimeWithMoment
