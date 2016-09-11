
Template.clinicals.functions

  $options: this:true

  tableFields: -> [
    { key: '_id', label: 'CS#', sortOrder:1, sortDirection:'descending', hidden:true}
    { key: 'tissue', label:'Tissue' }
    { key: 'subject', label:'Subject' }
    { key: 'indication', label:'Indication' }
    { key: 'surgeon', label:'Surgeon' }
    { key: 'place', label:'Place' }
    { key: 'dob', label:'DOB', fn:@formatDate, sortByValue:true }
    { key: 'sex', label:'Sex' }
    # { key: 'locationName', label:'Location', fn:(value) -> value ? 'none' }
  ]
