rendered = {}
removed  = {}

Nav._renderView = (template, data, target) ->
  rendered =
    template:template
    data:data
    target:target

  # # template.viewName = Template.testing
  # console.log 'rendering template:',template
  # # data is what i provide
  # console.log 'rendering data:',data
  # # target is the jquery element wrapper
  # console.log 'rendering target:',target


Nav._removeView = (view) ->
  # console.log 'removing:',view
  removed = view

Tinytest.add 'Nav.addView', (test) ->

  Nav.addView
    testing:
      blah: 'blah'

  test.isNotNull Nav._views.testing
  test.equal rendered.template.viewName, 'Template.testing'
  test.equal rendered.data.blah(), 'blah'
  test.isNotNull rendered.target


  Nav.addView
    testing2:
      blah2: 'blah2'

  # still there
  test.isNotNull Nav._views.testing

  test.isNotNull Nav._views.testing2
  test.equal rendered.template.viewName, 'Template.testing2'
  test.equal rendered.data.blah2(), 'blah2'
  test.isNotNull rendered.target

Tinytest.add 'Nav.setView', (test) ->

  Nav.setView
    testing3:
      blah3: 'blah3'

  test.isUndefined Nav._views.testing
  test.isUndefined Nav._views.testing2

  test.equal rendered.template.viewName, 'Template.testing3'
  test.equal rendered.data.blah3(), 'blah3'
  test.isNotNull rendered.target

Tinytest.add 'Nav.clearViews', (test) ->

  Nav.clearViews()

  test.isUndefined Nav._views.testing
  test.isUndefined Nav._views.testing2
  test.isUndefined Nav._views.testing3
  test.equal Object.keys(Nav._views).length, 0, 'views should be empty'

Tinytest.add 'Nav.clearViewsExcept', (test) ->

  Nav.addView
    testing:
      blah:'blah'
    testing2:
      blah2:'blah2'
    testing3:
      blah3:'blah3'

  test.isNotNull Nav._views.testing
  test.isNotNull Nav._views.testing2
  test.isNotNull Nav._views.testing3

  Nav._clearViewsExcept testing:true, testing3:true

  test.isNotNull Nav._views.testing
  test.isUndefined Nav._views.testing2
  test.isNotNull Nav._views.testing3

  Nav._clearViewsExcept testing3:true

  test.isUndefined Nav._views.testing
  test.isUndefined Nav._views.testing2
  test.isNotNull Nav._views.testing3
  test.equal Object.keys(Nav._views).length, 1

# TODO:

# share.callDestroy
# share.callCreate
