
only30 = (value) ->
  if value?.length > 27
    value = value[...27] + '...'

  return value

Template.projects.functions

  $options: this:true

  tableFields: -> [
    { key: '_id', label: 'ID', sortOrder:1, sortDirection:'ascending', hidden:true }
    { key: 'name', label: 'Name' }
    { key: 'description', label:'Description', fn: only30 }
  ]
