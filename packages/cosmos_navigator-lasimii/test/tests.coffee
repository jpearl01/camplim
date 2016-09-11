Tinytest.add 'setDefault', (test) ->
  object = setDefault:share.setDefault, _defaultLocation:null
  location = '/some/location'
  object.setDefault location
  test.equal object._defaultLocation, location

names = [ 'layout', 'sidebar', 'menu', 'item', 'id' ]
layout = layout = 'one'
sidebar = sidebar = 'two'
menu = menu = 'three'
item = item = 'four'
id = id = 'five'
expected = layout:layout, sidebar:sidebar, menu:menu, item:item, id:id
parts = [ '', layout, sidebar, menu, item, id ]
location = parts.join '/'
stripIndex = 4
stripOneAndGetParams = ->
  expected[names[stripIndex]] = undefined
  parts.pop()
  --stripIndex
  location = parts.join '/'
  share.paramsOf location

Tinytest.add 'paramsOf with all parts', (test) ->

  params = share.paramsOf location
  test.equal params[name], expected[name] for name in names

Tinytest.add 'paramsOf without id', (test) ->

  params = stripOneAndGetParams()
  test.equal params[name], expected[name] for name in names

Tinytest.add 'paramsOf without item', (test) ->

  params = stripOneAndGetParams()
  test.equal params[name], expected[name] for name in names

Tinytest.add 'paramsOf without menu', (test) ->

  params = stripOneAndGetParams()
  test.equal params[name], expected[name] for name in names

Tinytest.add 'paramsOf without sidebar', (test) ->

  params = stripOneAndGetParams()
  test.equal params[name], expected[name] for name in names

Tinytest.add 'paramsOf without layout', (test) ->
  expected.layout = 'LasimiiSampleLayout'
  location = '/'
  params = share.paramsOf location
  test.equal params[name], expected[name] for name in names


# TODO: param stuff, non-R, R, get/setAll, equals

Tinytest.add 'set all params to undefined', (test) ->

  Nav._setParams layout:undefined,sidebar:undefined,menu:undefined,item:undefined,id:undefined

Tinytest.add 'get non-existent non-reactive params', (test) ->

  test.isUndefined Nav.params[name] for name in names

Tinytest.add 'get non-existent reactive params', (test) ->

  test.isUndefined Nav.getParam name for name in names

Tinytest.add 'non-existent reactive params equals undefined', (test) ->

  test.isTrue Nav.paramEquals name, undefined for name in names


Tinytest.add 'set all params to a value', (test) ->
  expected = layout:'la', sidebar:'si', menu:'m', item:'i', id:'i'
  Nav._setParams expected

Tinytest.add 'get existent non-reactive params', (test) ->

  test.equal Nav.params[name], expected[name] for name in names

Tinytest.add 'get existent reactive params', (test) ->

  test.equal Nav.getParam(name), expected[name] for name in names

Tinytest.add 'existent reactive params equals expected value', (test) ->

  test.isTrue Nav.paramEquals name, expected[name] for name in names


Tinytest.addAsync 'lasimii forwards / to default location', (test, done) ->
  # set the default location for `redirect()` to find
  Nav._defaultLocation = theDefault = '/default'

  # replace setLocation so we can grab its call
  calledSetLocation = false
  originalSetLocation = Nav.setLocation
  Nav.setLocation = (shouldBeDefault) ->
    calledSetLocation = true
    # ensure it's forwarding to the default we set
    test.equal shouldBeDefault, theDefault
    # restore original function
    Nav.setLocation = originalSetLocation

  context = path:'/'

  share.redirect.call context

  setTimeout (->
    test.isTrue calledSetLocation, 'should have called Nav.setLocation'
    done()
  ), 10

Tinytest.addAsync 'lasimii doesnt forward path to default location unless its /', (test, done) ->
  Nav._defaultLocation = theDefault = '/default'
  calledSetLocation = false
  originalSetLocation = Nav.setLocation
  Nav.setLocation = -> calledSetLocation = true

  context = location:'/some/path'
  share.redirect.call context

  setTimeout (->
    test.isFalse calledSetLocation, 'should NOT call Nav.setLocation'
    Nav.setLocation = originalSetLocation
    done()
  ), 10


Tinytest.add 'lasimii processes location into params', (test) ->

  paramsObject =
    layout: 'one'
    sidebar: 'two'
    menu: 'three'
    item: 'four'
    id: 'five'
    main: 'ThreeFour'

  context = path: '/one/two/three/four/five'

  share.analyze.call context

  # lasimii gets params, *and* sets view info

  test.isTrue context.view?, 'should have a view info object'

  one = context.view.one

  test.isTrue one?, 'should have the layout as a property'
  test.equal one.sidebar, 'two'
  test.equal one.menu, 'three'
  test.equal one.item, 'four'
  test.equal one.id, 'five'
  test.equal one.main, 'ThreeFour'

  test.equal context.params, paramsObject


Tinytest.add 'test atMenuItem helper when true', (test) ->
  Nav._setParams menu:'menu', item:'item'
  result = Blaze._globalHelpers.atMenuItem 'menu', 'item'
  test.equal result, 'active'

Tinytest.add 'test atMenuItem helper when item is wrong', (test) ->
  Nav._setParams menu:'menu', item:'item'
  result = Blaze._globalHelpers.atMenuItem 'menu', 'other'
  test.isUndefined result

Tinytest.add 'test atMenuItem helper when menu is wrong', (test) ->
  Nav._setParams menu:'menu', item:'item'
  result = Blaze._globalHelpers.atMenuItem 'other', 'item'
  test.isUndefined result

Tinytest.add 'test atMenuItem helper when both are wrong', (test) ->
  Nav._setParams menu:'menu', item:'item'
  result = Blaze._globalHelpers.atMenuItem 'some', 'other'
  test.isUndefined result


Tinytest.add 'test notAtMenuItem helper when it is at them', (test) ->
  Nav._setParams menu:'menu', item:'item'
  result = Blaze._globalHelpers.notAtMenuItem 'menu', 'item'
  test.isUndefined result

Tinytest.add 'test notAtMenuItem helper when item is wrong', (test) ->
  Nav._setParams menu:'menu', item:'item'
  result = Blaze._globalHelpers.notAtMenuItem 'menu', 'other'
  test.equal result, 'disabled'

Tinytest.add 'test notAtMenuItem helper when menu is wrong', (test) ->
  Nav._setParams menu:'menu', item:'item'
  result = Blaze._globalHelpers.notAtMenuItem 'other', 'item'
  test.equal result, 'disabled'

Tinytest.add 'test notAtMenuItem helper when both are wrong', (test) ->
  Nav._setParams menu:'menu', item:'item'
  result = Blaze._globalHelpers.notAtMenuItem 'some', 'other'
  test.equal result, 'disabled'
