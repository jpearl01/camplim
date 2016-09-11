Template.profile.onCreated ->
  Template.instance().changingPasswordVar = new ReactiveVar false

Template.profile.helpers

  profileName: -> Meteor.user()?.profile?.name

  primaryEmail: -> Meteor.user()?.emails?[0]?.address

  changingPassword: -> Template.instance().changingPasswordVar.get()

Template.profile.events

  'click .change-password-button': (event, template) ->
    template.changingPasswordVar.set true
    Meteor.defer -> $('input[name=currentPassword]').focus()

  'click .cancel-change-button': (event, template) ->
    template.changingPasswordVar.set false

  'submit #PasswordForm, click .make-change-button': (event, template) ->
    event.preventDefault()

    currentPassword = $(template.find 'input[name=currentPassword]').val()
    newPassword = $(template.find 'input[name=newPassword]').val()

    if currentPassword?.length < 8 or newPassword?.length < 8
      Notify.error 'Passwords must be at least 8 characters.'
      return

    Accounts.changePassword currentPassword, newPassword, (error, result) ->
      if error?
        if error?.reason is 'Incorrect password'
          Notify.error 'The current password you provided is incorrect.'
        else
          Notify.error 'We had trouble changing your password, please retry.'
        console.log 'Error while changing password:',error
      else
        Notify.success 'Password changed.'
        template.changingPasswordVar.set false
