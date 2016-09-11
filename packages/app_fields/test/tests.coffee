input = null

Tinytest.add 'date field label', (test) ->

  label = $('label[for=\'dfName\']')
  test.isNotUndefined label
  test.equal label.html(), 'dfLabel'

Tinytest.add 'date field input', (test) ->

  input = $('input#dfName')
  test.isNotUndefined input

Tinytest.add 'date field input attribute: name', (test) ->

  test.equal input.attr('name'), 'dfName'


Tinytest.add 'date field input attribute: date', (test) ->

  test.equal input.attr('type'), 'date'


Tinytest.add 'date field input attribute: class', (test) ->

  clazz = input.attr 'class'
  test.isTrue (clazz.indexOf 'DF' > -1)
