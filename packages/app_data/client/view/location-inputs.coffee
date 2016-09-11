theTemplate = Template.location

theTemplate.profiles [ 'CosmosForm', 'AVE' ]

theTemplate.names =
  singular: 'location'
  plural  : 'locations'
  capital : 'Location'

theTemplate.onCreated this:true, fn: ->
  @autorun =>
    id = Nav.getParam 'id'
    if id? then @subscribe 'InLocation', id

theTemplate.helpers

  $options: this:true

  things: ->
    console.log 'things!'
    Meteor.$db.InLocation.find()
