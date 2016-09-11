
Tinytest.add 'Nav is enhanced with hash', (test) ->

  test.isNotUndefined Nav._hash, 'should have Nav._hash'
  test.isNotUndefined Nav.getHash, 'should have Nav.getHash'
  test.isNotUndefined Nav.setHash, 'should have Nav.setHash'


Tinytest.add 'Nav.setHash', (test) ->

  Nav.setHash 'value'
  test.equal Nav.hash, 'value'
  test.equal Nav._hash.get(), 'value'


Tinytest.add 'Nav.getHash', (test) ->

  test.equal Nav.getHash(), 'value'


Tinytest.add 'Nav.hashEquals', (test) ->

  test.isTrue Nav.hashEquals('value')
  test.isFalse Nav.hashEquals('other')
