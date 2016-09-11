Template.registerHelper 'isParam', (name, value) -> Nav.paramEquals name, value

Template.registerHelper 'isParamNot', (name, value) -> not Nav.paramEquals name, value
