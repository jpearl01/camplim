# Nav is the global object to control the browser location, location state,
# and get its location reactively.
Nav =

  # tells if Nav is currently running
  running: false

  # (non-reactive) a string containing the browser location's path/query/hash
  location: null

  # reactive version of the above value
  _location: new ReactiveDict()

  # convenience function to set both location values
  _setLocations: (location) ->
    location ?= @_buildLocation()

    # non-reactive
    @location = location.location
    @queryString = location.query
    @hash = location.hash

    # clear reactive store first.
    @_location.clear()
    # reactive (triggers trackers)
    @_location.set location


  # returns reactive values
  getHash: -> Nav._location.get 'hash'
  getLocation: -> Nav._location.get 'location'
  getOriginalLocation: -> Nav._location.get 'original'
  getPath: -> Nav._location.get 'path'
  getQueryString: -> Nav._location.get 'query'

  # changes the current location to the specified one
  setLocation: (newLocation) -> Nav._newState newLocation # TODO: encode this?

  # store builder functions from @addBuilder(fn) for @to(string)
  _builders: [
    # because I ended up storing Nav.hash in navigator-location, add its builder. blarg.
    (values, combine=true) ->
      hash = if combine is true or combine?.hash is true
          values.hash ? Nav.hash
        else
          values.hash
      if hash? then values.location += '#' + hash
  ]

  buildLocationFor: (values, combine=true) -> # TODO: provide full values to use when clicking
    # give `values` to each builder function to build `values.location`
    each values, combine for each in @_builders
    return values?.location

  # unfortunately yet another change requires I push more functionality into
  # navigator-location. :(
  # now we need to be able to do more than Nav.setLocation(string), and,
  # we need a way for the extending packages to provide functionality to help
  # this build the new location for Nav.to(object).
  # so, i'm going to use "builder" functions. see @addBuilders()
  # advanced setLocation which accepts params, query string, and hash.
  # if those root properties aren't specified then the current values are used
  # values.params handled by a path analyzing package, lasimii or route
  # values.query handled by navigator-query-analyzer, or other query handler
  # values.hash is so simple its handled by this packages
  # values.matrix is handled by a matrix analyzer, like: navigator-matrix-analyzer
  # TODO: make a `to` helper which accepts values
  # TODO: store this info so after @setLocation we can avoid parsing and use them.
  to: (values) ->
    combine = values?.combine
    location = @buildLocationFor values, combine
    # if they made a location, then, use it
    if location? then @setLocation location

  # adds actions to call when the location changes
  onLocation: (action) -> # TODO: validate it's a function
    Tracker.autorun (c) ->
      # Nav.reload() will trigger this tracker causing this autorun to rerun
      Nav._reloadTracker.depend()

      # get all the reactive values
      all = Nav._location.all()

      # then add computation to it in case they want to stop it later...
      all.computation = c

      if not c.firstRun and all.path? then action.call Nav, all
    return

  # use history to move back `count` number of times
  # TODO: ensure we don't move back passed Nav loading?
  back: (count=1) -> @history.go -1 * count

  forward: (count=1) -> @history.go count

  # use in autoruns so reload() can trigger them to run again
  _reloadTracker: new Tracker.Dependency()

  # trigger all onLocation autoruns to rerun
  reload: ->
    Nav.isReload = true
    @_reloadTracker.changed()

  # allow a preferredIndex so builders can be specify their preferred order...
  # blarg.
  addBuilder: (builder, preferredIndex=1024) ->
    if preferredIndex <= @_builders.length then @_builders.splice preferredIndex, 0, builder
    else @_builders.push builder

  # add more state info to the current state
  addState: (moreState) -> @_putState Nav.state, moreState

  setBasepath: (basepath) -> @basepath = basepath

  # change hashbang implementations to either use hashbangs or not
  setHashbangEnabled: (enabled) -> @_hashbangEnabled = enabled

  # set state in the browser's push api for the current location
  setState: (state={}) -> @_putState state

  # configure with options and set location to current browser location
  # triggering actions
  start: (options) ->
    @_setup options
    @running = true
    @_setLocations()
    return true

  # remove listeners which essentially stops this from doing anything
  stop: () ->
    @running = false
    # remove event listeners
    document.removeEventListener @_clickType(), @_handleClick, false
    window.removeEventListener 'popstate', @_handlePopstate, false
    return true # shows we successfully completed the stop() function

  _basepathPrepend: (location) ->
    if @basepath? and location[...@basepath.length] isnt @basepath
      @basepath + location
    else location

  _basepathStrip: (location) ->
    if @basepath? and location[...@basepath.length] is @basepath
      location[@basepath.length..]
    else location

  # uses the browser's location object to build the current location
  _buildLocation: ->
    # Wow, providing more than just the location considerably complicated this.
    # first, store the original full location
    info =
      original: @_decodeThis @_the.location.pathname + @_the.location.search + @_the.location.hash

    # get the location without both the basepath and hashbang
    info.location = @_hashbangStrip @_basepathStrip info.original

    # if we're currently using a hashbang then the browser's location doesn't
    # have the individual info, so, get it from `info.location`
    if @_hashbangEnabled
      parts = info.location.split(/\?|#/)
      info.path  = parts[0]
      info.query = parts?[1]
      info.hash  = parts?[2]

    # else, without a hashbang complicating things, get each from browser's location
    else
      # strip the basepath, if it is there, from the `pathname`
      info.path  = @_basepathStrip @_decodeThis @_the.location.pathname
      info.query = @_decodeThis @_the.location.search
      info.hash  = @_decodeThis @_the.location.hash

    # strip off the symbols from the front
    if info.query?[0] is '?' then info.query = info.query[1..]
    if info.hash?[0] is '#' then info.hash = info.hash[1..]

    # ensure undefined instead of an empty string
    if info.query?.length is 0 then delete info.query
    if info.hash?.length is 0 then delete info.hash

    return info

  # sets click event based on existence of `ontouchstart`
  _clickType: -> if document?.ontouchstart? then 'touchstart' else 'click'

  # decode value
  _decodeThis: (value) ->
    if typeof value isnt 'string' then return value
    decodeURIComponent value.replace /\+/g,' '

  #
  _elementPath: (el) ->
    path = el.pathname + el.search + (el?.hash ? '')
    pattern = /^\/[a-zA-Z]:\//
    path = path.replace pattern, '/' if process? and path.match pattern
    return path

  # listener for popstate events. builds location and sets it into values
  # triggering actions
  _handlePopstate: (event) ->
    unless document.readyState is 'complete' then return
    Nav.state = event.state
    Nav._setLocations()
    return

  # NOTE: implementation basically from visionmedia/pagejs
  # listener for click events. filters out clicks which we ignore handling
  # such as 'mailto:'.
  _handleClick: (event) ->
    # return if not a simple click or it's already prevented.
    if Nav._which event isnt 1 or
      event?.metaKey? or event?.ctrlKey? or event?.shiftKey? or
      event.defaultPrevented
        return

    # get anchor element above the clicked element
    el = event.target # TODO: better way to find parent anchor element?
    until not el? or el?.nodeName is 'A' then el = el?.parentNode
    unless el?.nodeName is 'A' then return

    # Ignore if tag has: 1. "download" attribute; 2. rel="external" attribute
    if el.hasAttribute 'download' or el.getAttribute 'rel' is 'external'
      return

    link = el.getAttribute 'href'
    if el.pathname is Nav._the.location.pathname and (el?.hash or link is '#')
      return

    if link?.indexOf('mailto:') > -1 then return

    if el?.target then return

    if el?.origin? and el.origin isnt Nav._origin() then return
    if el?.href?.indexOf(Nav._origin()) isnt 0 then return

    location = Nav._elementPath el

    event.preventDefault()

    if location is Nav.location then return # if new path is same as old path...

    Nav._newState location

    return

  _hashbangPrepend: (location) ->
    # TODO: ensure the specified location starts with a slash after hashbang?
    if @_hashbangEnabled and location[...4] isnt '/#!/' then '/#!' + location
    else location

  _hashbangStrip: (location) ->
    if @_hashbangEnabled and location[...4] is '/#!/' then location[3..] else location

  # create a new state by pushing it onto history and then set the new location
  # used by Nav.setLocation() and click event handler.
  _newState: (location, state) ->
    Nav.state = state
    # location *with* basepath and hashbang
    # TODO: anchor tags should have this info so they display correctly...
    fullLocation = @_basepathPrepend @_hashbangPrepend location
    @history.pushState state, document.title, fullLocation
    @_setLocations()

    return true

  # get the origin of the current location URL
  _origin: ->
    # try getting from the browser's location object
    origin = @_the.location?.origin
    # if we didn't get it above...
    unless origin?
      # build it from parts
      origin = @_the.location.protocol + '//' + @_the.location.hostname +
        if @_the.location?.port? then ':' + @_the.location.port else ''
    return origin

  _putState: (state, extraState={}) ->
    if state?
      Nav.state = state
      state[key] = value for own key,value of extraState
    else Nav.state = extraState

    @history.replaceState Nav.state, document.title, @_location.get 'original'
    return

  # setup Nav based on options.
  _setup: (options) ->
    @_the =
      # TODO: or, store the history.length value, and don't go before that...
      locationCount: 0 # TODO: use this ;)
      location: window?.history?.location ? window.location

    # store History object on Nav.
    # if there is a history pushState function then we're fine.
    if window?.history?.pushState?
      @history = window.history

    # there's no push state API, so, enable hashbangs now and provide an
    # alternate history implementation.
    # TODO: there's a history push state polyfill. add that with a conditional
    #       comment to support IE browsers. what about other old browsers? hmm.
    else
      @setHashbangEnabled true
      # add NOOP implementations.
      # TODO:
      #  implement these for browsers which don't have a history API.
      #  we'd have to track our
      #  pushState should change the browser location with a hashbang location
      #  replaceState should only update the stored state for the location.
      #
      @history = {
        pushState:(->), replaceState:(->), go:(->)
      }

    @_decode = unless options?.decode then ((v)->v) else @_decodeThis

    unless options?.click is false # TODO: clicks element selector?
      document.addEventListener @_clickType(), @_handleClick, false

    unless options?.popstate is false
      window.addEventListener 'popstate', @_handlePopstate, false

    if options?.hashbang is true then @setHashbangEnabled true

    if options?.basepath? then @setBasepath options.basepath

    return true

  # get the which/button value
  _which: (event) -> # TODO:? shorten to: event?.which ? window?.event?.button
    event ?= window?.event
    return event?.which ? event.button

# TEMPORARY BUG FIX
# ReactiveDict.clear() errors after a Hot Code Reload because the [key]
# portion of the self.keyValueDeps is undefined.
# so, i'm overriding it to prevent that problem by
# checking for it via a simple '?', go coffeescript.
# fixed in meteor's next release.
changed = (v) -> v && v.changed()

ReactiveDict::clear = () ->
  oldKeys = @keys
  @keys = {}

  @allDeps.changed()

  for key,value of oldKeys
    changed(@keyDeps[key])
    changed(@keyValueDeps[key]?[value])
    changed(@keyValueDeps[key]?['undefined'])
