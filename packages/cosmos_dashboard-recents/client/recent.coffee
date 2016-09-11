# Meteor.$fn.makeListTemplate 'recents'

name = 'recents'

theTemplate = Template.ReactiveTable.renderAs name

# theTemplate.profiles [ 'ReactiveTable' ]

tableName = 'recents-table'
filterName = 'recents-table-filter'
filters = [] # [ filterName ]

theTemplate.helpers
  $options: this:true

  filterFields: -> []
  filterLabel: -> 'Search'
  tableId: tableName
  tableFilterId: -> # filterName

  tableSettings: ->
    collection: Meteor.$db.recents #tableName
    showFilter: false
    filters: filters
    showNavigation: 'auto'
    showColumnToggles: true
    fields: [
      { key: '_id', label: 'ID', hidden:true}
      { key: 'name', label:'Type'}
      { key: 'lastVisited', label:'Viewed', sortOrder:1, sortDirection:'descending', fn:@formatDateTime, sortByValue:true }
      { key: 'refId', label:'ID' }
      { key: 'from', label:'Where', hidden:true }
      { key: 'collection', label: 'Group', hidden:true }
    ]


#theTemplate = Template.recents

theTemplate.onCreated this:true, fn: ->

  @autorun =>
    type = Nav.getParam 'item'
    unless type? then type = Nav.getParam 'menu'
    name = 'recent-' + type
    # console.log 'subscribe to:',name
    # Subs.subscribe name
    @subscribe name


theTemplate.functions

  $options: this:true

  formatDateTime: 'MomentInput'

theTemplate.events
  $options: this:true

  'click .reactive-table tr': ->
    Nav.to
      params:
        sidebar:@data.from  # people / data
        menu:@data.name     # member / specimen / etc
        item:'view'         # we want to view it
        id:@data.refId      # the _id of it
      combine:'params'      # use other current params
