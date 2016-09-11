Template.registerHelper 'isMatrix', (groupName, valueName, value) ->

  Nav.matrixEquals groupName, valueName, value

Template.registerHelper 'isMatrixNot', (groupName, valueName, value) ->

  not Nav.matrixEquals groupName, valueName, value
