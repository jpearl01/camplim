#theTemplate = Template.BootstrapInput.renderAs 'ParentSpecimen'
theTemplate = Template.ParentSpecimen

theTemplate.profiles [ 'CosmosFormInput', 'RefInput' ]

theTemplate.onCreated this:true, fn: ->
  if Nav.paramEquals 'item', 'add'
    parentType = Nav.getQuery 'type'
    parentId   = Nav.getQuery 'id'
    if parentType? and parentId?
      thing = @findThing()
      console.log 'have them both, so, is there a thing yet:',thing
      thing.set 'parentType', parentType
      thing.set 'parentId', parentId

theTemplate.helpers
  $options: this:true

  # get these from another profile
  staticFieldClass: 'BootstrapFormInput'
  fieldContainerClass: 'BootstrapFormInput'
  editIconClass: ->
    iconClass = @template.findKey 'editIconClass'
    unless iconClass?
      if Nav.paramEquals 'item', 'add'
        iconClass = 'glyphicon glyphicon-pencil'
      else
        iconClass = 'hidden' # parent field is immutable once set, right?
        # what if they make a mistake??

  # add these helpers
  name: 'parentId'
  parentType: -> @findThing().get 'parentType'
  parentId: -> @findThing().get 'parentId'
  parentItem: -> @findThing().getParentItem()
  hasError: -> @findThing().hasValidationError 'parentId'
  getError: -> @findThing().getValidationError 'parentId'
  noopEditmode: get:(-> true),set:(->)

theTemplate.functions
  $options: this:true

  showModal: -> # do nothing. we don't show a modal. they must select a search result

  buildSearchOptions: ->
    options =
      fields: _id:1
      sort  : ['_id', 'asc']
      limit : 10

    options.name =  @findThing().getParentName() + '-search-id'

    return options

  storeSuggestion: (suggestion) ->
    @event.preventDefault()

    thing = @findThing()

    # TODO: dont do this?
    if thing.get('parentId') is suggestion._id
      @template.editmode.set false
      return

    thing.set 'parentId', suggestion._id


theTemplate.events
  $options: this:true

  'click a.parent-link': ->
    # console.log 'click parent-link'
    @event.noEditmode = true

  # when they select a new parentType clear parentId field
  'click a.button-choice': ->
    #newParentType = $(@event.target).text()
    # have they already made their modification?
    # if so, we can get the value via thing.parentType

    # 1. if parentType has *changed* then clear the val() of parentId, then focus on parentId

    # 2. otherwise...
    thing = @findThing()
    newValue = thing.getModified().parentType?
    if newValue
      input = @template.$('input')[1]
      input = $ input
      input.typeahead('val','')
      Meteor.defer -> input.focus()

  'click .cancel-button, keyup input': ->
    if @event.type is 'keyup' and @event.keyCode isnt 27 then return
    # console.log 'PARENT click .cancel-button...'
    thing = @findThing()
    @revertValue thing, 'parentId'
    @revertValue thing, 'parentType'
    @template.editmode.set false
