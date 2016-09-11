
Template.specimens.functions

  $options: this:true

  tableFields: -> [
    { key: '_id', label: 'S#', sortOrder:1, sortDirection:'descending'}
    { key: 'projectName', label: 'Project' }
    { key: 'dateCollected', label:'Collected', fn:@formatDate, sortByValue:true }
    { key: 'dateReceived', label:'Received', fn:@formatDate, sortByValue:true }
    { key: 'collaboratorName', label:'Collaborator' }
    { key: 'loggedByName', label: 'Logged By'}
    { key: 'locationName', label:'Location'}
  ]
