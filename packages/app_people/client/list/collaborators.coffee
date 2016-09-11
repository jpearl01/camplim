
Template.collaborators.functions

  $options: this:true

  tableFields: -> [
    { key: '_id', label: 'ID', hidden:true}
    { key: 'name', label: 'Name', sortOrder:1, sortDirection:'ascending' }
    { key: 'organization', label:'Organization' }
    { key: 'phone', label:'Phone' }
    # { key: 'address', label:'Address', hidden:true }
  ]
