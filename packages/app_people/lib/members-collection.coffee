if Meteor.isServer
  Accounts.onCreateUser (options, user) ->
    console.log 'creating user'
    console.log '  options:',options
    console.log '  user:',user
    # the default hook's 'profile' behavior
    if options?.profile?
      user.profile = options.profile
    # create a corresponding Member with the same _id
    Meteor.$db.members.insert {
      _id:user._id
      name:user?.profile?.name
      email: options.email ? user?.emails?[0]?.address
      createdAt: new Date()
      createdById: '0'
      createdByName: 'User System'
    }
    #, (error, result) ->
      # if error? # send something to an admin or ...

    return user

Meteor.$db.users = Meteor.users

collection = Meteor.hoard 'members'
collection.options = importAllowed:true

collection.allow
  insert: -> true
  update: -> true
  remove: -> false

Meteor.$things.member = collection.Thing = Member = Astro.Class

  name: 'Member'
  collection: collection
  fields:
    name:
      type: 'string'
      validator: Validators.required()
    email:
      type: 'string'
      validator: Validators.regexp(/.+@.+/, 'Provide a valid email (a@b)')
    phone:
      type: 'string'
      validator: Validators.phone()
    jobTitle: 'string'
    office: 'string'
  behaviors:
    when: {}
    customs: {}
    refUpdate:
      member  : in: 'users', id: '_id', name: 'profile.name'
      loggedBy: in: 'specimens'
      storedBy: in: 'bacteria'
      madeBy  : in: 'constructs'

  indexes:
    name:
      fields:
        name:1

if Meteor.isServer
  Member.extend
    events:
      afterChange: (event) ->
        unless event.operation is 'set' then return

        # if email was changed then update the Users collection
        if event.data.fields?.email?
          newEmail = event.data.fields.email
          oldEmail = Meteor.user().emails?[0]?.address
          userId = Meteor.userId()

          # 1. add new email
          Accounts.addEmail userId, newEmail

          # 2. remove old email
          if oldEmail? # check just in case... should always be one
            Accounts.removeEmail userId, oldEmail
