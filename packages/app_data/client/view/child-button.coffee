Template.ChildButton.functions
  $options: this:true

  toAdd: (type) ->
    @event.preventDefault()
    console.log 'toAdd data:',@data
    Nav.to
      params:
        menu: type
        item: 'add'
        id  : null
      query:
        type: @data.type
        id  : @data.id

Template.ChildButton.events
  $options: this:true

  'click .new-specimen': -> @toAdd 'specimen'

  'click .new-clinical': -> @toAdd 'clinical'

  'click .new-bacterium': -> @toAdd 'bacterium'

  'click .new-construct': -> @toAdd 'construct'
