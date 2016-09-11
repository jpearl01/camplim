analyze = ->

  # move query string to a new variable to retain it
  this.queryString = this.query

  # use `qs` to parse the query string
  this.query = Nav._querystring.parse this.query


# now take the values we put into `this` and store them into Nav
apply = -> Nav.setQuery this.query

builder = (values, combine=true) ->
  query = {}
  # if we're using the current values then get them all
  if combine is true or combine?.query is true
    query[key] = value for own key,value of Nav.query

  # override the current query values with specified values
  if values.query?
    query[key] = value for own key,value of values.query

  # stringify them
  query = Nav._querystring.stringify query

  # if there's actually a value then prepend the question mark
  if query?.length > 0 then query = '?' + query

  # # include in location after path and before hash

  # if no location yet, just put query in there
  if not values.location? then values.location = query

  # else there is a location already, if it starts with the hash, add query before it
  else if values.location[0] is '#'
    values.location = query + values.location

  # if it starts with a path
  else if values.location[0] is '/'
    # look for the hash part
    index = values.location.indexOf '#'
    # if we find it, add the query in the middle, before the hash
    if index > -1
      values.location = values.location[...index] + query + values.location[index...]
    # else append it after the path (there's no hash)
    else
      values.location += query

  # else, what do we do?
  else console.log 'error, unknown location format, unable to include query'


# add the location builder so query values are used. prefer being first (0)
Nav.addBuilder builder, 0

# ensure we have the phase we need
Nav.phasor.add id:'Apply', before:'Actions'

# add the phase actions
Nav.phasor.add id:'Apply', fn:apply
Nav.phasor.add id:'Analyze', fn:analyze

# change the location by changing only these query values
Nav.setQuery ?= (query) -> Nav.to query:query

# store in share for testing
share.analyze = analyze
share.apply = apply
share.builder = builder
