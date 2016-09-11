
# avoid the standard phases for testing
Nav.phasor._array = []
Nav.phasor._phases = []
Nav.phasor._phaseCounts = {}

Tinytest.add 'Nav.phasor add phases', (test) ->

  phases = [ 'first', 'second', 'third']
  Nav.phasor.add id:id for id in phases

  test.equal Nav.phasor._array.length, 0, 'shouldnt have any actions'
  test.equal Nav.phasor._phases.length, 3, 'should have the three phases'
  for phase,index in phases
    test.equal Nav.phasor._phases[index], phase, "phase [#{phase}] should be at #{index}"
    test.equal Nav.phasor._phaseCounts[phase], 0, "phase [#{phase}] should have a count of zero"

Tinytest.add 'Nav.phasor add phase actions', (test) ->

  fn0 = ->
  fn1 = ->
  fn2 = ->
  fn3 = ->
  fn4 = ->
  fn5 = ->
  fn6 = ->

  Nav.phasor.add id:'first', fn:fn1
  test.equal Nav.phasor._array[0], fn1
  test.equal Nav.phasor._phaseCounts['first'], 1

  Nav.phasor.add id:'second', fn:fn3
  test.equal Nav.phasor._array[1], fn3
  test.equal Nav.phasor._phaseCounts['second'], 1

  Nav.phasor.add id:'third', fn:fn5
  test.equal Nav.phasor._array[2], fn5
  test.equal Nav.phasor._phaseCounts['third'], 1

  Nav.phasor.add id:'second', fn:fn2
  test.equal Nav.phasor._array[1], fn2
  test.equal Nav.phasor._phaseCounts['second'], 2

  Nav.phasor.add id:'third', fn:fn4
  test.equal Nav.phasor._array[3], fn4
  test.equal Nav.phasor._phaseCounts['third'], 2

  Nav.phasor.add id:'first', fn:fn0
  test.equal Nav.phasor._array[0], fn0
  test.equal Nav.phasor._phaseCounts['first'], 2

  Nav.phasor.add id:'third', fn:fn6
  test.equal Nav.phasor._array[4], fn6
  test.equal Nav.phasor._phaseCounts['third'], 3

Tinytest.add 'Nav.phasor run', (test) ->
  fn = -> fn.count++
  # store on function so we can use it in the next test
  fn.count = 0
  Nav.phasor._array[index] = fn for each,index in Nav.phasor._array

  Nav.phasor.run()

  test.equal fn.count, Nav.phasor._array.length, 'should run once for each one'

  # reset for the next test
  fn.count = 0

Tinytest.add 'Nav.phasor stop running', (test) ->

  Nav.phasor._array[2] = -> false

  Nav.phasor.run()

  test.equal Nav.phasor._array[0].count, 2, 'should stop after two'

Tinytest.add 'repeated add is ignored', (test) ->

  same = 'same'
  Nav.phasor.add id:same
  Nav.phasor.add id:same
  Nav.phasor.add id:same

  count = 0
  count++ for phase in Nav.phasor._phases when phase is same

  test.equal count, 1, 'should only be a single instance of the phase'
