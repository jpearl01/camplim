Meteor.methods

  sendWish: (wish) ->
    user = Meteor.user()
    name = user?.profile?.name
    email = user?.emails?[0]?.address
    Email.send
     from: email
     to: 'eli+camplim@elidoran.com'
     subject: 'Camplim Wish'
     html: "<div>#{name}</div><div>#{email}</div><br/><div>#{wish}</div>"
