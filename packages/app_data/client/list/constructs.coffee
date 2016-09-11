
Template.constructs.functions

  $options: this:true

  tableFields: -> [
    { key: '_id', label: 'GC#', sortOrder:1, sortDirection:'descending', hidden:true}
    { key: 'genotype', label:'Genotype' }
    { key: 'plasmid', label: 'Plasmid' }
    { key: 'resistance', label:'Resistance' }
    { key: 'concentration', label:'Concentration' }
    { key: 'locationName', label:'Location', fn:(value) -> value ? 'none' }
    { key: 'madeByName', label: 'Made By'}
    { key: 'dateMade', label:'Made', fn:@formatDate, sortByValue:true }
  ]
