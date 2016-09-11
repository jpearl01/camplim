
Template.VerifyEmail.onRendered ->
  token = Nav.getParam 'id'
  if token?
    Accounts.verifyEmail token, ->
      Meteor.defer -> Notify.success 'Email Verified!'
      # TODO: Meteor.setTimeout ...
      Nav.setLocation '/'
