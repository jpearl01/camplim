
Template.bacteria.functions

  $options: this:true

  tableFields: -> [
    { key: '_id', label: 'BS#', sortOrder:1, sortDirection:'descending', hidden:true}
    { key: 'species', label: 'Species'}
    { key: 'strain', label:'Strain' }
    { key: 'phenotype', label:'Phenotype' }
    { key: 'storedByName', label: 'Stored By'}
    # passages... { key: '', label:'' }
    { key: 'locationName', label:'Location', fn:(value) -> value ? 'none' }
    { key: 'dateFrozen', label:'Frozen', fn:@formatDate, sortByValue:true }
  ]
