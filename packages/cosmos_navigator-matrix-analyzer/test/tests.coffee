
Tinytest.add 'Nav is enhanced with matrix', (test) ->

  test.isNotUndefined Nav.matrix, 'should have Nav.matrix'
  test.isNotUndefined Nav._matrix, 'should have Nav._matrix'
  test.isNotUndefined Nav.getMatrix, 'should have Nav.getMatrix'
  test.isNotUndefined Nav.setMatrix, 'should have Nav.setMatrix'
  test.isNotUndefined Nav.addMatrix, 'should have Nav.addMatrix'
  test.isNotUndefined Nav.matrixEquals, 'should have Nav.matrixEquals'


Tinytest.add 'Nav.addMatrix', (test) ->

  Nav.addMatrix 'item', color:'blue', size:'large'

  test.equal Nav.matrix.item.color, 'blue'
  test.equal Nav.matrix.item.size, 'large'
  test.isTrue Nav._matrix.item.equals('color', 'blue')
  test.isTrue Nav._matrix.item.equals('size', 'large')


Tinytest.add 'Nav.getMatrix', (test) ->

  test.equal Nav.getMatrix('item', 'color'), 'blue'
  test.equal Nav.getMatrix('item', 'size'), 'large'

  item = Nav.getMatrix 'item'

  test.equal item.get('color'), 'blue'
  test.equal item.get('size'), 'large'


Tinytest.add 'Nav.setMatrix', (test) ->

  Nav.setMatrix 'item', {color:'red', nosize:true}

  test.isTrue Nav._matrix.item.equals('color', 'red')
  test.isUndefined Nav._matrix.item.get('size')


Tinytest.add 'Nav.matrixEquals', (test) ->

  test.isTrue Nav.matrixEquals('item', 'color', 'red')
  test.isTrue Nav.matrixEquals('item', 'nosize', true)
  test.isFalse Nav.matrixEquals('item', 'size', 'large')
