# weak dependency, set once and allow updating
Dashboard = Meteor.$db?.dashboard
if Dashboard?
  eximMenu = Dashboard.findOne name:'exim'
  unless eximMenu?
    Dashboard.insert
    # Dashboard.upsert order:10,
      order:10
      name: 'exim'
      title: 'EXIM'
      defaultLocation: '/dashboard/exim/import/pending'
      mainSize: 'col-sm-10 col-sm-offset-2'
      sidebarSize: 'col-sm-2'
      sections: [
        {
          menu: 'import', title: 'Import', class:'glyphicon glyphicon-import'
          menus: [
            { menu: 'pending', title: 'Imports', class:'glyphicon glyphicon-play'}
            { menu: 'start', title: 'Start Import', class:'glyphicon glyphicon-upload'}
            { menu: 'maps', title: 'Import Maps', class:'glyphicon glyphicon-random'}
          ]
        }

        # {
        #   menu: 'export', title: 'Export', class:'glyphicon-export'
        #   menus: [
        #     { menu: 'pending', title: 'Exports', class:'glyphicon glyphicon-play'}
        #     { menu: 'start', title: 'Start Export', class:'glyphicon glyphicon-download'}
        #     # { menu: 'maps', title: 'Export Maps', class:'glyphicon glyphicon-random'}
        #   ]
        # }
      ]
