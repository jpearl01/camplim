Template.dsidebar.onCreated ->

  @autorun => # TODO: need a router-agnostic way to get the value...
    @subscribe 'DashboardContext', Nav.getParam 'sidebar'

Template.dsidebar.helpers

  context: -> Dashboard.findOne name:Nav.getParam 'sidebar'

  locationValues: (menu, item) ->
    if typeof(item) isnt 'string' then item = null
    values =
      params:
        menu:menu
        item:(item ? null)
        id:''
      combine:
        params:true
    return values
