
Tinytest.add 'Nav is enhanced with params', (test) ->

  test.isNotUndefined Nav.params, 'should have Nav.params'
  test.isNotUndefined Nav._params, 'should have Nav._params'
  test.isNotUndefined Nav.getParam, 'should have Nav.getParam'
  test.isNotUndefined Nav._setParams, 'should have Nav._setParams'
  test.isNotUndefined Nav._addParams, 'should have Nav._addParams'
  test.isNotUndefined Nav.paramEquals, 'should have Nav.paramEquals'


Tinytest.add 'Nav._addParams', (test) ->

  Nav._addParams some:'value'
  test.equal Nav.params.some, 'value'
  test.isTrue Nav._params.equals('some', 'value')


Tinytest.add 'Nav.getParam', (test) ->

  test.equal Nav.getParam('some'), 'value'


Tinytest.add 'Nav._setParams', (test) ->

  Nav._setParams diff:'thing'
  test.equal Nav.params.diff, 'thing'
  test.isTrue Nav._params.equals('diff', 'thing')
  test.isUndefined Nav.params.some
  test.isFalse Nav._params.equals('some', 'value')


Tinytest.add 'Nav.paramEquals', (test) ->

  test.isTrue Nav.paramEquals('diff', 'thing')
  test.isFalse Nav.paramEquals('diff', 'false')
