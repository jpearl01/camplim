delay = Meteor?.settings?.TEST_DELAY ? 100

location1 = '/some/path'
hashedLocation1 = '/#!' + location1
basepath1 = '/basepath'
basepathLocation1 = basepath1 + location1
basepathHashbangLocation1 = basepath1 + hashedLocation1

encoded =
  location1: '/some%20sample/path%20name'
  hashedLocation1: '/#!/some%20sample/path%20name'
  basepath1: '/base%20path'
  basepathLocation1: '/base%20path/some%20sample/path%20name'
  basepathHashbangLocation1: '/base%20path/#!/some%20sample/path%20name'

decoded =
  location1: '/some sample/path name'
  hashedLocation1: '/#!/some sample/path name'
  basepath1: '/base path'
  basepathLocation1: '/base path/some sample/path name'
  basepathHashbangLocation1: '/base path/#!/some sample/path name'

reset = ->
  Nav.setHashbangEnabled false
  Nav.setBasepath null
  Nav.setLocation '/'


Tinytest.addAsync 'setLocation with encoded', (test, done) ->
  Nav.setLocation encoded.location1
  setTimeout (->
    test.equal Nav.location, decoded.location1
    test.equal Nav.getLocation(), decoded.location1
    test.equal location.pathname, encoded.location1

    test.equal Nav._location.get('original'), decoded.location1
    test.isUndefined Nav._location.get('query')
    test.isUndefined Nav._location.get('hash')

    done()
  ), delay

Tinytest.addAsync 'setLocation', (test, done) ->
  Nav.setLocation location1
  setTimeout (->
    test.equal Nav.location, location1
    test.equal Nav.getLocation(), location1
    test.equal location.pathname, location1
    done()
  ), delay

Tinytest.add 'setHashbangEnabled', (test) ->
  reset()

  Nav.setHashbangEnabled true

  test.equal Nav._hashbangPrepend(location1), hashedLocation1
  test.equal Nav._hashbangPrepend(hashedLocation1), hashedLocation1

  test.equal Nav._hashbangStrip(location1), location1
  test.equal Nav._hashbangStrip(hashedLocation1), location1

  reset()

  test.equal Nav._hashbangPrepend(location1), location1
  test.equal Nav._hashbangPrepend(hashedLocation1), hashedLocation1

  test.equal Nav._hashbangStrip(location1), location1
  test.equal Nav._hashbangStrip(hashedLocation1), hashedLocation1

Tinytest.addAsync 'setLocation with hashbang enabled', (test, done) ->
  reset()

  Nav.setHashbangEnabled true
  Nav.setLocation location1
  setTimeout (->
    test.equal Nav.location, location1
    test.equal Nav.getLocation(), location1
    test.equal location.pathname + location.hash, hashedLocation1
    Nav.setHashbangEnabled false
    done()
  ), delay

Tinytest.add 'setBasepath', (test) ->
  reset()

  Nav.setBasepath basepath1

  test.equal Nav._basepathPrepend(location1), basepathLocation1
  test.equal Nav._basepathPrepend(basepathLocation1), basepathLocation1

  test.equal Nav._basepathStrip(location1), location1
  test.equal Nav._basepathStrip(hashedLocation1), hashedLocation1
  test.equal Nav._basepathStrip(basepathLocation1), location1

  reset()

  test.equal Nav._basepathPrepend(location1), location1
  test.equal Nav._basepathPrepend(basepathLocation1), basepathLocation1

  test.equal Nav._basepathStrip(location1), location1
  test.equal Nav._basepathStrip(hashedLocation1), hashedLocation1
  test.equal Nav._basepathStrip(basepathLocation1), basepathLocation1

Tinytest.addAsync 'setLocation with a basepath', (test, done) ->
  reset()

  Nav.setBasepath basepath1
  Nav.setLocation location1
  setTimeout (->
    test.equal Nav.location, location1
    test.equal Nav.getLocation(), location1
    test.equal location.pathname + location.hash, basepathLocation1
    Nav.setBasepath null
    done()
  ), delay

Tinytest.add 'setBasepath with setHashbangEnabled', (test) ->
  reset()

  Nav.setHashbangEnabled true
  Nav.setBasepath basepath1

  test.equal Nav._basepathPrepend(Nav._hashbangPrepend(location1)), basepathHashbangLocation1

  test.equal Nav._hashbangStrip(Nav._basepathStrip(location1)), location1
  test.equal Nav._hashbangStrip(Nav._basepathStrip(hashedLocation1)), location1
  test.equal Nav._hashbangStrip(Nav._basepathStrip(basepathLocation1)), location1

  reset()

  test.equal Nav._basepathPrepend(Nav._hashbangPrepend(location1)), location1
  test.equal Nav._basepathPrepend(Nav._hashbangPrepend(hashedLocation1)), hashedLocation1
  test.equal Nav._basepathPrepend(Nav._hashbangPrepend(basepathLocation1)), basepathLocation1
  test.equal Nav._basepathPrepend(Nav._hashbangPrepend(basepathHashbangLocation1)), basepathHashbangLocation1

  test.equal Nav._hashbangStrip(Nav._basepathStrip(location1)), location1
  test.equal Nav._hashbangStrip(Nav._basepathStrip(hashedLocation1)), hashedLocation1
  test.equal Nav._hashbangStrip(Nav._basepathStrip(basepathLocation1)), basepathLocation1
  test.equal Nav._hashbangStrip(Nav._basepathStrip(basepathHashbangLocation1)), basepathHashbangLocation1

Tinytest.addAsync 'setLocation with a basepath and hashbang', (test, done) ->
  reset()

  Nav.setHashbangEnabled true
  Nav.setBasepath basepath1
  Nav.setLocation location1

  setTimeout (->
    test.equal Nav.location, location1
    test.equal Nav.getLocation(), location1
    test.equal location.pathname + location.hash, basepathHashbangLocation1
    done()
  ), delay

Tinytest.add 'setState', (test) ->
  reset()

  Nav.setLocation '/set/state'
  Nav.setState some:'value'
  test.isNotNull Nav.state
  test.equal Nav.state.some, 'value'

Tinytest.add 'addState', (test) ->
  Nav.addState another:'value'
  test.isNotNull Nav.state
  test.equal Nav.state.some, 'value'
  test.equal Nav.state.another, 'value'

Tinytest.addAsync 'back()', (test, done) ->
  Nav.setLocation '/back'
  Nav.setLocation '/forward'

  setTimeout (->
    test.isUndefined Nav.state
    test.equal Nav.location, '/forward'
    test.equal location.pathname, '/forward'
    Nav.back()
  ), delay

  setTimeout (->
    test.equal Nav.location, '/back'
    test.equal location.pathname, '/back'
    Nav.setLocation '/forward'
  ), delay * 2

  setTimeout (->
    Nav.back 2
  ), delay * 3

  setTimeout (->
    test.equal Nav.location, '/set/state'
    test.equal location.pathname, '/set/state'

    test.isNotNull Nav?.state, 'Nav.state should exist'
    test.isNotNull Nav?.state?.some, 'nav.state.some should exist'
    test.isNotNull Nav?.state?.another, 'nav.state.another should exist'

    test.equal Nav?.state?.some, 'value'
    test.equal Nav?.state?.another, 'value'

    done()
  ), delay * 4

Tinytest.addAsync 'forward()', (test, done) ->

  Nav.forward()

  setTimeout (->
    test.equal Nav.location, '/back'
    test.equal location.pathname, '/back'

    Nav.back()
  ), delay

  setTimeout (->
    test.equal Nav.location, '/set/state'
    test.equal location.pathname, '/set/state'

    Nav.forward 2
  ), delay * 2

  setTimeout (->
    test.equal Nav.location, '/forward'
    test.equal location.pathname, '/forward'
    reset()
    done()
  ), delay * 3

Tinytest.addAsync 'onLocation', (test, done) ->
  query = 'one=1%201&two=2'
  hash = 'some%20hash'

  decodedQuery = 'one=1 1&two=2'
  decodedHash = 'some hash'

  tail = '?' + query + '#' + hash
  decodedTail = '?' + decodedQuery + '#' + decodedHash

  fullLocation = encoded.location1 + tail
  fullOriginal = encoded.basepathHashbangLocation1 + tail

  decodedFullLocation = decoded.location1 + decodedTail
  decodedFullOriginal = decoded.basepathHashbangLocation1 + decodedTail

  fn = (info) ->
    test.equal info.original, decodedFullOriginal, 'original should have it all'
    test.equal info.location, decodedFullLocation, 'location shouldnt have basepath or hashbang'
    test.equal info.path, decoded.location1, 'path should equal location without basepath, hashbang, query, and hash'
    test.equal info.query, decodedQuery
    test.equal info.hash, decodedHash
    test.isNotNull info.computation, 'should have a computation'
    test.equal this, Nav
    test.equal this.location, decodedFullLocation
    setTimeout (-> done()), 50

  Nav.onLocation fn
  Nav.setHashbangEnabled true
  Nav.setBasepath decoded.basepath1
  Nav.setLocation fullLocation


# TODO:
#  test handleClick by passing an event object which triggers each conditional
#  check in there.
