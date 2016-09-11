Nav.params = {}

Nav._params  ?= new ReactiveDict 'Nav Params'

Nav.getParam ?= (name) -> @_params.get name

Nav.paramEquals ?= (key, value) -> @_params.equals key, value

Nav._addParams ?= (params) ->
  @params[key] = params[key] for key of params
  @_params.set params

Nav._setParams ?= (params) ->
  @params = params
  @_params.clear()
  @_params.set params
