# always subscribe to this so we have the main Dashboard info
Meteor.subscribe 'Dashboard'

# track the most recent location for each sidebar value
# used to set the `href` for the headers
Nav = Package?['cosmos:navigator-location']?.Nav
if Nav?.getParam?
  Tracker.autorun ->
    sidebar = Nav.getParam 'sidebar'
    Session.set "recent-#{sidebar}", Nav.location

# TODO:
#  alternately use kadira:flow-router to get the sidebar param...
#  for that, have to setup a route into FlowRouter for the lasimii format...
#  if they're using FlowRouter, then, that makes this package work, but,
#  it means the dashboard package would be adding a route... hmm.
