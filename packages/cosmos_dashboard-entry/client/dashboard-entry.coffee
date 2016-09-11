
entryPathPrefix = /^\/dashboard\/entry/i

Nav.phasor.add id:'Exit', fn: (info) ->
  if not (entryPathPrefix.test(info.path) or Meteor.userId()?)
    # record where they were heading to send them there after login
    Meteor.__returnAfterLogin = info.location
    Meteor.setTimeout (-> Nav.setLocation '/dashboard/entry/login'), 10
    return false


Tracker.autorun (c) ->
  
  # skip first run, when no longer logged in, send to login
  # (do userId() first to create dependency on first run)
  if not (Meteor.userId()? or c.firstRun)
    path = Nav.location
    if path # path is undefined when app first loads (first time this runs)
      Meteor.__returnAfterLogin = path
      # empty out session when logging out
      if Session?.clear? then Session.clear()
      else Session.keys = {}
      # TODO put this in Tracker.afterFlush() ?
      Nav.setLocation '/dashboard/entry/login'
