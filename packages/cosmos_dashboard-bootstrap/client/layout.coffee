toggleWithDashboard = -> $('body').toggleClass 'with-dashboard'

Template.dashboard.onCreated   toggleWithDashboard
Template.dashboard.onDestroyed toggleWithDashboard
