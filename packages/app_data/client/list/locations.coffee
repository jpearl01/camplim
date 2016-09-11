
Template.locations.functions

  $options: this:true


  tableFields: -> [
    { key: '_id', label: 'ID', sortOrder:1, sortDirection:'descending', hidden:true}
    { key: 'room', label: 'Room'}
    { key: 'rack', label: 'Rack'}
    { key: 'shelf', label: 'Shelf'}
    { key: 'box', label: 'Box'}
    { key: 'cell', label: 'Cell'}
    { key: 'isFreezer', label:'Type', fn: (value) -> if value then 'Freezer' else 'Fridge' }
    { key: 'createdByName', label: 'Created By'}
    { key: 'dateCreated', label:'Created', fn:@formatDate, sortByValue:true }
    { key: 'name', label:'Name' } #, hidden:true }
  ]
