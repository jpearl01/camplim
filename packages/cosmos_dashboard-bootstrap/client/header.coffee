
Template.dheader.onCreated ->

  @autorun =>
    #@subscribe 'Dashboard' # done in cosmos:dashboard so it's always available
    # console.log 'subscribing to DashboardContexts in header'
    @subscribe 'DashboardContexts' # this stays here tho??

Template.dheader.helpers

  headerTitle: -> Dashboard.findOne(order:0)?.title  # TODO: separate header title and document title
  headerDefaultLocation: -> Dashboard.findOne(order:0)?.defaultLocation ? '/'

  context: -> Dashboard.find {order:$gt:0}, sort:order:1

  getRecent: (contextName) -> # get the most recent menu we went to in that sidebar, or its default
    # TODO: don't store the sidebar name to location map here...store in Dashboard
    result = Session.get "recent-#{contextName}"
    result ?= Dashboard.findOne(name:contextName)?.defaultLocation
    return result

  isActive: (name) -> # get if this is the current sidebar
    # TODO: change to get sidebar from Nav
    if Nav.paramEquals 'sidebar', name then 'active'
    #if name is FlowRouter.getParam 'sidebar' then 'active'

  userDisplayName: -> Meteor.user()?.profile?.name

Template.dheader.events

  # 'click a.context-link': (event, template) ->
  #   console.log 'click the link'
  #   console.log '  event:',event
  #   console.log '  template:',template

  # TODO: move this to dashboard-users
  'click #userLogoutLink': (event, template) ->
    event.preventDefault()
    Meteor.logout (error) ->
      if error?
        console.log 'Logout error: ', error
        Notify.error "Please retry logout because: ", error.reason
      #else
        # do nothing, the tracker will do this. tho, now that we're handling
        # this, we could handle the redirect right here.
        # but, i prefer having it depend on Meteor.userId() to ensure any logout
        # will cause the redirect and session clear
