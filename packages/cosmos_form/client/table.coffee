
Template.profiles

  $options: this:true

  ReactiveTable:

    helpers:

      filterFields: -> []

      filterLabel: -> 'Search'

    events:

      'click .reactive-table tr': ->
        id = @data._id
        menu = @template.viewMenuId
        if id? and menu? then Nav.setParams menu:menu, item:'view', id:id

      'click #reactiveTableAddButton': -> Nav.setParams menu:@template.viewMenuId, item:'add'


    functions:

      formatDate: 'MomentInput'
