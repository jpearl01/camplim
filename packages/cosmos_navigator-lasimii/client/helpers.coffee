Template.registerHelper 'atSidebarMenu', (sidebar, menu) ->
  if Nav.paramEquals('sidebar', sidebar) and Nav.paramEquals('menu', menu) then 'active'

Template.registerHelper 'notAtSidebarMenu', (sidebar, item) ->
  unless (Nav.paramEquals('sidebar', sidebar) and Nav.paramEquals('menu', menu)) then 'disabled'


Template.registerHelper 'atMenuItem', (menu, item) ->
  if Nav.paramEquals('menu', menu) and Nav.paramEquals('item', item) then 'active'

Template.registerHelper 'notAtMenuItem', (menu, item) ->
  unless (Nav.paramEquals('menu', menu) and Nav.paramEquals('item', item)) then 'disabled'

Template.registerHelper 'atPart', (partName, partValue) ->
  Nav.paramEquals partName, partValue
  
