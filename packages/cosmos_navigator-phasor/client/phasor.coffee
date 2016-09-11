# actions are grouped into 'phases'
# order is only required at the inter-phase level.
# within a phase any order is acceptable
Nav.phasor =

  _queue: []

  add: (options) ->
    # TODO: remove message for production...
    unless Meteor?.settings?.public?.silencePhasorQueueing
      console.log 'Nav.phasor.add() not yet implemented. Storing until initialize.',options
    @_queue.push options

  run: (context) -> console.log 'Nav.phasor.run() not yet implemented'

  _init: ->
    standardPhases = ['Analyze', 'Exit', 'Enter', 'Before', 'Action', 'After']
    @add id:id for id in standardPhases

    # empty array and delete it
    while @_queue.length > 0 then @add @_queue.shift()
    delete @_queue


# this reacts to location changes and reloads.
# it runs the phases via setTimeout to leave the reactivity context.
Nav.onLocation (context) ->
  # the `this` has all the values. provide it to the run function as the context
  setTimeout (-> Nav.phasor.run(context)), 0
