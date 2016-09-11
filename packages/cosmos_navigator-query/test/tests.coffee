
Tinytest.add 'Nav is enhanced with query', (test) ->

  test.isNotUndefined Nav.query, 'should have Nav.query'
  test.isNotUndefined Nav._query, 'should have Nav._query'
  test.isNotUndefined Nav.getQuery, 'should have Nav.getQuery'
  test.isNotUndefined Nav._setQuery, 'should have Nav._setQuery'
  test.isNotUndefined Nav._addQuery, 'should have Nav._addQuery'
  test.isNotUndefined Nav.queryEquals, 'should have Nav.queryEquals'


Tinytest.add 'Nav._addQuery', (test) ->

  Nav._addQuery some:'value'
  test.equal Nav.query.some, 'value'
  test.isTrue Nav._query.equals('some', 'value')


Tinytest.add 'Nav.getQuery', (test) ->

  test.equal Nav.getQuery('some'), 'value'


Tinytest.add 'Nav._setQuery', (test) ->

  Nav._setQuery diff:'thing'
  test.equal Nav.query.diff, 'thing'
  test.isTrue Nav._query.equals('diff', 'thing')
  test.isUndefined Nav.query.some
  test.isFalse Nav._query.equals('some', 'value')


Tinytest.add 'Nav.queryEquals', (test) ->

  test.isTrue Nav.queryEquals('diff', 'thing')
  test.isFalse Nav.queryEquals('diff', 'false')
