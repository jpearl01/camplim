# Publish the Dashboard
Meteor.publish 'Dashboard', ->
  #console.log 'Publish the dashboard'
  result = Dashboard.find order:0
  #console.log 'AFTER Publish the dashboard'
  return result

# Publish all the remaining fields for the active dashboard context
Meteor.publish 'DashboardContext', (name) ->
  if name?
    #console.log 'Publish current dashboard context name=', name
    result = Dashboard.find name:name #if name? then name:name else order:1
    #console.log 'AFTER Publish current dashboard context name=', name
  return result

# Publish each Dashboard context, but, restrict its fields to the header info
headersOptions =
  sort:
    order:1 # each context must be configured with an `order` to sort them
  fields:
    order:1 # do we need the order in the client too? i don't think so...
    name:1
    title:1  # name to display  TODO: run thru L10N...
    defaultLocation:1 # default menu item to display for context
    permissions:1 # may restrict access to certain contexts
    footer:1

Meteor.publish 'DashboardContexts', (options) ->
  #console.log 'Publish DashboardContexts'
  #options = if options.headers then headersOptions else {}
  result = Dashboard.find {}, headersOptions#options
  #console.log 'AFTER Publish DashboardContexts'
  return result

# Meteor.methods
#
#   # an admin with permission could add/edit/remove contexts...
#   someDashboardOp: ->
