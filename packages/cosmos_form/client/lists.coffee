Meteor.$fn.makeListTemplate = (name) ->
  theTemplate = Template.ReactiveTable.renderAs name

  theTemplate.profiles [ 'ReactiveTable' ]

  singular = if name[-1..] is 's' then name[...-1] else name
  if name is 'bacteria' then singular = 'bacterium'

  theTemplate.onCreated this:true, fn: ->
    @template.viewMenuId = singular

  tableName = name + '-table'
  filterName = tableName + '-filter'
  filters = [ filterName ]

  theTemplate.helpers
    $options: this:true

    tableId: -> tableName

    tableSettings: ->
      collection: tableName
      showFilter: false
      filters: filters
      showNavigation: 'auto'
      showColumnToggles: true
      fields: @tableFields()

    tableFilterId: -> filterName
