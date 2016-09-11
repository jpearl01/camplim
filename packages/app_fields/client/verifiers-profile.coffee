Template.profiles
  Verifiers:
    functions:
      $makeRequired: (theTemplate) -> (string) ->
        if string?.length > 0
          theTemplate.__hasError = null
          return true
        else
          return theTemplate.__hasError = 'Must provide a value'
