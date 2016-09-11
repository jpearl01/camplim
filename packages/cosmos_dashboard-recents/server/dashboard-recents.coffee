# TODO: allow specifying the order elsewhere...
# TODO:, or, just add it without order and let them set the `order` value
# TODO: move this out of cosmos:dashboard-recents... it's app:recents...
Dashboard.upsert order:1,
  order:1
  name: 'recents'
  title: 'Recent'
  defaultLocation: '/dashboard/recents/specimens'
  mainSize: 'col-sm-10 col-sm-offset-2'
  sidebarSize: 'col-sm-2'
  sections: [
    { menu: 'all', title: 'All', class:'', isLink:true }

    {
      menu: 'data', title: 'Data', class:'', isLink:true
      menus: [
        { menu: 'projects', title: 'Projects', class:''}
        { menu: 'specimens', title: 'Specimens', class:''}
        { menu: 'clinicals', title: 'Clinical Specimens', class:''}
        { menu: 'bacteria', title: 'Bacteria Stocks', class:''}
        { menu: 'constructs', title: 'Genomic Constructs', class:''}
        # { menu: 'nucleics', title: 'Nucleic Acids', class:''}
        { menu: 'locations', title: 'Locations', class:''} # glyphicon glyphicon-th-large
      ]
    }

    {
      menu: 'people', title: 'People', class:'', isLink:true
      menus: [
        { menu: 'members', title: 'Members', class:''}
        { menu: 'collaborators', title: 'Collaborators', class:''}
      ]
    }
  ]
