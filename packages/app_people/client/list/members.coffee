
Template.members.functions

  $options: this:true

  tableFields: -> [
    { key: '_id', label: 'ID', hidden:true}
    { key: 'name', label: 'Name', sortOrder:1, sortDirection:'ascending' }
    { key: 'phone', label: 'Phone'}
    { key: 'email', label:'Email'}
    { key: 'jobTitle', label: 'Title' }
    { key: 'office', label: 'Office'}
    { key: 'createdAt', label: 'Created', fn:@formatDate, sortByValue:true, hidden:true }
  ]
