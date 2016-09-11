Astro.createType
  name: 'Date'

  constructor: -> Astro.BaseField.apply this, arguments

  needsCast: (value) -> not (value instanceof Date)

  cast: (value) -> new Date value.replace /-/g, '/'

  plain: (value) -> value
