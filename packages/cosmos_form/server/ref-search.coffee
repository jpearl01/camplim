
defaultOptions = -> limit:10, fields:{name:1}, sort:['name','asc']

Meteor.$fn.refSearch = (collection, query, options) ->
  if options?
    options.limit = Math.min 10, Math.abs options.limit
    options.sort ?= sort:['name','asc']
    options.fields ?= name:1
  else
    options ?= defaultOptions()

  console.log 'ref search'
  console.log '  options:',options
  console.log '  query:',query

  # TODO: check `query` for any characters not allowed in regex, like '\'
  # Meteor._sleepForMs 2000
  # need non-global with caret for indexed, which makes a 'prefix' index
  #regex = new RegExp "#{query}", 'gi'
  regex = new RegExp "^#{query}", 'i'
  cursor = collection.find {name:{$regex:regex}}, options
  cursor.fetch()

Meteor.$fn.makeSearch = (name) ->
  collection = Meteor.$db[name]
  methods = {}
  methods[name + '-search'] = (query, options) -> Meteor.$fn.refSearch collection, query, options
  Meteor.methods methods

Meteor.$fn.idSearch = (name) ->
  store = Meteor.$db[name]
  methods = {}
  methods[name + '-search-id'] = (query, options) ->
    if options?
      options.limit = Math.min 10, Math.abs options.limit
      options.sort ?= sort:['_id','asc']
      options.fields ?= _id:1
    else
      options ?= limit:10, sort:['_id':1], fields:_id:1

    # console.log 'search-id',name
    # console.log '  options:',options
    # console.log '  query:',query

    # TODO: check `query` for any characters not allowed in regex, like '\'

    # need non-global with caret for indexed, which makes a 'prefix' index
    #regex = new RegExp "#{query}", 'gi'
    regex = new RegExp "^#{query}", 'i'
    cursor = store.find {_id:{$regex:regex}}, options
    cursor.fetch()

  Meteor.methods methods
