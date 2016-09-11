# if `Nav.phasor` available then use it  (this is how to get a *weak* dependency)
if Package?['cosmos:navigator-phasor']?
  phasor = Package['cosmos:navigator-location'].Nav.phasor

  # add a phase before Actions so we can destroy views after Before and before Actions
  phasor.add id:'ViewDestroy', after:'Before'

  # add a phase after Actions so we can render views after Actions and before After
  phasor.add id:'ViewCreate', after:'Action'

  # now add functions to those phases which do the work
  phasor.add id:'ViewDestroy', fn: share.callDestroy = ->

    # if there's view info for us to handle...
    if this.view?
      # if this is a Nav.setView operation then $set is true
      if this.view.$set
        # delete the set marker
        delete this.view.$set
        # clear the views except those specified to render
        Nav._clearViewsExcept Nav.view

      # null out the view data for views which already exist and we're changing
      Nav._nullViewData this.view
      Tracker.flush()

  phasor.add id:'ViewCreate', fn: share.callCreate = ->
    
    # whether it was a $set or add, we always do _addView.
    if this.view? then Nav._addView this.view
