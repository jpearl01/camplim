Nav.query = {}

Nav._query  ?= new ReactiveDict 'Nav Query'

Nav.getQuery ?= (name) -> @_query.get name

Nav.queryEquals ?= (key, value) -> @_query.equals key, value

Nav.addQuery ?= (query) ->
  @query[key] = query[key] for key of query
  @_query.set query

Nav.setQuery ?= (query) ->
  @query = query
  @_query.clear()
  @_query.set query
