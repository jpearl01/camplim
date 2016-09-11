Template.registerHelper 'isQuery', (name, value) -> Nav.queryEquals name, value

Template.registerHelper 'isQueryNot', (name, value) -> not Nav.queryEquals name, value
