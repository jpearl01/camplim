Views =

  # hold default target element IDs mapped by layout names.
  # the default target for all layouts is the body tag.
  _targetMap: _default:'body'

  # set a default targetId
  setLayoutTargetDefault: (targetId) -> @_targetMap['_default'] = targetId

  # set targetId for layoutName to the map
  setLayoutTarget: (layoutName, targetId) -> @_targetMap[layoutName] = targetId

  # hold info for all views currently displayed
  _views: {}

  # add to rendered views
  # NOTE:
  #  this is for direct calls. when in the phasor run, set the `options`
  #  object into the context as `view`, and the phasor functions we added
  #  will handle the rest.
  addView: (options) ->
    # make changing data values null first to trigger onDestroyed
    @_nullViewData options

    # if there is an action (function) to call in between these two...
    if options?.between?
      options?.between()
      delete options.between

    # now add views and set real data values to trigger onCreated
    @_addView options

    return

  _nullViewData: (options) ->
    # console.log '_nullViewData: ',options
    for layoutName, layoutValues of options
      # if the view already exists, we want to nullify its changing data values
      # get view info
      viewInfo = @_views?[layoutName]
      if viewInfo? # if it exists
        # null dict value for each key (except `target`)
        for key,value of layoutValues when key isnt 'target'
          # don't nullify it if the new value equals the old value
          unless viewInfo.dict.equals key, value
            viewInfo.dict.set key, null

    return

  _addView: (options) ->
    # console.log '_addView: ',options
    for layoutName, layoutValues of options
      viewInfo = @_views?[layoutName]
      if viewInfo? # if it exists

        # TODO: should we save it, and put it back?
        delete layoutValues.target
        @_buildDataGetters layoutValues, viewInfo.dict, viewInfo.data

      else # create the view

        # TODO: could get the template in a function like:
        #  Blaze.render(Blaze.With(data, function () { return Template.myTemplate; }))
        # then if `layout` doesn't exist, we can use a special error template to
        # show it doesn't exist...
        # and, when layout does exist, we can change the layout reactively just
        # like the data context. so, no need to make a new view in a root element

        # need `template`
        template = Template?[layoutName]
        unless template?
          # TODO: write to console and return instead of error?
          console.log 'No `template` for',layoutName
          throw new Error "Views.addView(): No template with name `#{layoutName}`"
        #console.log 'template is: ',template

        # need `target`
        # 1. get target ID from options or default targets map
        target = (layoutValues?.target ? @_targetMap?[layoutName]) ? @_targetMap?['_default']

        # 2. get target element
        target = $(target).get(0)

        #console.log 'target element is: ',target
        # 3. verify we have a target. when not, do we use a default root?
        unless target?
          # TODO: write to console and return instead of error?
          console.log 'No `target` for layout',layoutName
          throw new Error "Views.addView(): No `target` specified for layout `#{layoutName}`"

        # need the data getters
        # take out `target` from the layoutValues.
        delete layoutValues.target
        # create a new ReactiveDict for the view
        dict = new ReactiveDict()
        data = @_buildDataGetters layoutValues, dict
        #console.log 'data: ',data
        #for name,fn of data
        #  console.log "data[#{name}] = ",fn()

        # view = Blaze.renderWithData template, data, target
        view = @_renderView template, data, target
        @_views[layoutName] = view:view, dict:dict, data:data

    return

  _renderView: (template, data, target) ->
    Blaze.renderWithData template, data, target

  _buildDataGetters: (layoutValues, dict, data={}) ->
    #console.log 'buildDataGetters values: ',layoutValues
    for key,value of layoutValues
      # TODO: if it doesn't already exist *and* this isn't a new view
      # then we need to cause an update on the View so it'll use the new value
      #console.log "  loop: #{key} = #{value}"
      dict.set key, value
      data[key] = do (dict, key) -> -> dict.get key
      #console.log '  getter: ',data[key]()

    return data

  # removes all other views and renders those specified here
  setView: (options) ->
    #console.log 'Nav.setView() options: ',options

    # instead of clearing all of them, clear the ones we're not going to keep.
    @_clearViewsExcept options

    @addView options

    return

  _removeView: (view) -> Blaze.remove view

  _clearViewsExcept: (keep) ->
    for own name,info of @_views when not keep[name]?
      @_removeView info.view
      delete @_views[name]

  # removes all views or specified views
  clearViews: (names...) ->
    # clear views with the names given
    if names?.length > 0
      for name in names
        @_removeView @_views[name].view if @_views?[name]?
        delete @_views[name]

    else # clear all of them
      for key,info of @_views
        @_removeView info.view
        delete @_views[key]

    return

# if `Nav` is in use, then add to it  (this is how to get a *weak* dependency)
if Package?['cosmos:navigator-location']?.Nav?
  Nav = Package['cosmos:navigator-location'].Nav
  Nav[key] = value for own key,value of Views
  delete this.Views
