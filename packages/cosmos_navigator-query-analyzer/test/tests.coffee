
queryString = 'one=just one&two=2&thing[0]=first&thing[1]=second'
queryObject =
  one: 'just one'
  two: '2'
  thing: [ 'first', 'second' ]

Tinytest.add 'analyze ', (test) ->

  context = query:queryString

  share.analyze.call context

  test.isNotNull context.queryString
  test.equal context.queryString, queryString

  test.isNotNull context.query
  test.equal context.query, queryObject

Tinytest.add 'apply', (test) ->

  Nav.setQuery = (query) -> test.equal query, queryObject

  context = query:queryObject

  share.apply.call context

Tinytest.add 'builder without any query values', (test) ->

  values = {}
  share.builder values
  test.equal values.location, '?'

Tinytest.add 'builder without new query values', (test) ->

  Nav.query = test:'value'
  values = {}
  share.builder values
  test.equal values.location, '?test=value'

Tinytest.add 'builder with new and old query values', (test) ->

  Nav.query = test:'value'
  values = query: test2:'value2'
  share.builder values
  test.equal values.location, '?test=value&test2=value2'

Tinytest.add 'builder with new value overriding old query value', (test) ->

  Nav.query = test:'value'
  values = query: test:'value2'
  share.builder values
  test.equal values.location, '?test=value2'

Tinytest.add 'builder with path location', (test) ->

  Nav.query = {}
  values = location:'/some/path', query: test:'value'
  share.builder values
  test.equal values.location, '/some/path?test=value'

Tinytest.add 'builder with hash location', (test) ->

  Nav.query = {}
  values = location:'#somehash', query: test:'value'
  share.builder values
  test.equal values.location, '?test=value#somehash'

Tinytest.add 'builder with both path and hash in location', (test) ->

  Nav.query = {}
  values = location:'/some/path#somehash', query: test:'value'
  share.builder values
  test.equal values.location, '/some/path?test=value#somehash'
