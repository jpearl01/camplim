Template.profiles
  $options: this:true

  DateInput:
    functions:
      formatValue: (date) ->
        # if date? then @template.$formatDate date, 'YYYY-MM-DD'
        # must format for the browser's input type date ...
        if @template.editmode.get()
          if date?
            month = date.getMonth() + 1
            if month < 10 then month = '0' + month
            day = date.getDate()
            if day < 10 then day = '0' + day
            result = '' + date.getFullYear() + '-' + month + '-' + day
            # console.log 'formatted for the browser...',result
            return result
        # format to show to the user as a static string
        else
          date?.toLocaleDateString()


theTemplate = Template.BootstrapFormInput.renderAs 'DateInput'

theTemplate.profiles [ 'CosmosFormInput', 'BootstrapFormInput', 'DateInput' ]

theTemplate.helpers

  type: -> 'date'
  typeMarker: -> 'DI'
