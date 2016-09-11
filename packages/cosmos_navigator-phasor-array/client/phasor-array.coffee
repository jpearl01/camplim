# store all actions into a single array, in order, ready for execution
Nav.phasor._array = []
# track how many each phase has so we know where they are in the array
Nav.phasor._phaseCounts = {}
# track the phase IDs and their order
Nav.phasor._phases = []

# add a new phase before/after another phase, or at the end
# add an action to a phase, goes before other actions in the phase
Nav.phasor.add = (options) ->
  
  # id + fn means a new action in that phase
  if options.fn?
    #   this puts the new action *before* the other actions in that phase
    # find the index we need to add:
    index = 0
    # loop over the phases
    for phase in @_phases
      # when it ISNT the phase, add its `count` to the index
      if phase isnt options.id then index += @_phaseCounts[phase]
      # when we find the phase
      else
        # splice in the function at the index
        @_array.splice index, 0, options.fn
        # and increment the phase's count
        @_phaseCounts[phase]++
        break

  else
    # if we already have the phase, we're done
    if options.id in @_phases then return

    # find index of the phase this one belongs before or after
    index = @_phases.indexOf (options.after ? options.before)
    # if we found the phase...
    if index > -1
      # and we're aiming for after it then increment the index
      if options.after then index++ # if before or no before leave index as is
    # else, we didn't find one (maybe there wasn't one), so add to the end
    else index = @_phases.length

    @_phases.splice index, 0, options.id
    @_phaseCounts[options.id] = 0

Nav.phasor.run = (context) ->
  # what `this`, Nav? control? context? without a `this` we can do fn(context)
  # how do the actions stop the execution ?
  for fn in @_array
    result = fn.call context, context
    if result is false then break # must be an explicit false

# with the implementation in place go ahead and initialize the standard phases
Nav.phasor._init()
