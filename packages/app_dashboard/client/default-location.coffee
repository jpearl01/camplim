# update Nav with the default location when it changes
# console.log 'DASH: default location stuff'
Tracker.autorun ->
  dash = Dashboard.findOne order:0
  # console.log '  DASH:',dash
  # console.log '  DASH default location:',dash?.defaultLocation
  Nav.setDefault dash.defaultLocation if dash?.defaultLocation
  # if we are at '/' then forward now?
  if Nav.location is '/'
    setTimeout (-> Nav.setLocation dash.defaultLocation), 0
  # what is this for??
  # Nav.__dashboard = Dashboard
