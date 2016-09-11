Template.dmiddle.helpers

  sidebarId: ->  Dashboard.findOne(order:0)?.sidebar ? 'dsidebar'

  mainSize: ->
    sidebar = Nav.getParam 'sidebar'
    context = Dashboard.findOne name:sidebar
    return context?.mainSize ? 'col-sm-10 col-sm-offset-2'

  sidebarSize: ->
    sidebar = Nav.getParam 'sidebar'
    context = Dashboard.findOne name:sidebar
    return context?.sidebarSize ? 'col-sm-2'
