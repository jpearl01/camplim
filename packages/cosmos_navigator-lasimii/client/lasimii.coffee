
redirect = ->
  # forward to a default location if it's the root location
  if '/' is this.path
    if Nav._defaultLocation?
      # change the location after we're done here
      setTimeout -> Nav.setLocation Nav._defaultLocation, 0

    # return false so we stop execution of the phases...
    return false

analyze = ->

  # process the location expecting the lasimii format
  # store the location's params into the context
  this.params = paramsOf this.path

  # view maps layout name to its data values
  # TODO: this has layout in it, does that matter?
  this.view = {}
  this.view[this.params.layout] = this.params

apply = ->

  # now take the values we put into `this` and store them into Nav
  Nav._setParams this.params


# get params from location string: /layout/sidebar/menu/item/id?
paramsOf = (string) ->

  array = string.split '/'
  if string[0] is '/' then array.shift()
  if array.length > 0 and array[0] isnt ''
    params =
      layout : array[0]
      sidebar: array?[1]
      menu   : array?[2]
      item   : array?[3]
      id     : array?[4]

    # i changed this from the simple 5 params to possibly 4 params, so,
    # let's try some combo's to find a template
    #
    # 1. sidebar checked first...
    if Template[params.sidebar]?
      params.main = params.sidebar

    # 2. then menu
    else if params.menu? and Template[params.menu]?
      params.main = params.menu

    # 3. then: menu + item,  without and with capitals
    else if params.menu? and params.item?
      name = params.menu + params.item
      if Template[name]? then params.main = name
      else
        menu = params.menu[0].toUpperCase() + params.menu[1...]
        item = params.item[0].toUpperCase() + params.item[1...]
        name = menu + item
        if Template[name]? then params.main = name

  return params

builder = (values, combine=true) ->
  # for the builder, we want to do the path prefix of `location`

  # lasimii handles path/params stuff, not query or hash.
  params = values.params ? {}

  # build an array we can join with slashes
  # add an empty string so we have a slash in the front
  parts = [ '' ]

  # add each provided param, use the current one if not specified
  for name in ['layout', 'sidebar', 'menu', 'item', 'id']
    if params[name]? then parts.push params[name] # value = params[name]
    else if (combine or combine?.params) and (params[name] isnt null)
      value = Nav.getParam name
      if value? then parts.push value

  # join to get the path
  path = parts.join '/'

  # retain query string and hash, if they exist in `location` already
  if values.location?.length > 0 then values.location = path + values.location
  else values.location = path

  # we're done
  return

# accepts a location to display for '/'
Nav.setDefault = (defaultLocation) ->
  unless defaultLocation?
    throw new Error 'Nav.setDefault() requires either a string or an object'
  @_defaultLocation = defaultLocation

# add the builder so params are included for Nav.to(). prefer being second
Nav.addBuilder builder, 1

Nav.setParams = (params) -> Nav.to params:params, combine:params:true

# ensure we have the phases we need
Nav.phasor.add id:'Preanalyze', before:'Analyze'
Nav.phasor.add id:'Apply', before:'Action'

# add our actions to those phases
Nav.phasor.add id:'Preanalyze', fn:redirect
Nav.phasor.add id:'Analyze', fn:analyze
Nav.phasor.add id:'Apply', fn:apply

# share these for testing
share.redirect = redirect
share.analyze = analyze
share.apply = apply
share.paramsOf = paramsOf
share.builder = builder
share.setDefault = Nav.setDefault
