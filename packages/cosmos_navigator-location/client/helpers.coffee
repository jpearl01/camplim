Template.registerHelper 'to', (kw) ->
  data = kw.hash

  # make our own copy of the values object
  values = {}

  # then:
  #  1. look for values. if that's there, copy its contents
  if data?.values?
    values.params = data.values.params
    values.query = data.values.query
    values.hash = data.values.hash
    combine = data.values.combine

  else
    #  2. look for params/query/hash in data. copy those into the `values` object
    values[key] = data[key] for key in [ 'params', 'query', 'hash' ]

    #  3. other data values are params by default. assuming it doesn't have other data...
    for own key,value of data when key not in [ 'values', 'params', 'query', 'hash', 'combine' ]
      values.params ?= {}
      values.params[key] = value

    combine = data?.combine

  return Nav.buildLocationFor values, combine
