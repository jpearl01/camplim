trim = (string) -> if string?.length > 0 then string.replace(/^\s*|\s*$/g, "")
Template.forgot.events

  'submit #forgotForm': (event, template) ->

    event.preventDefault()

    info =
      email: trim template.find('#email').value

    unless info?.email?.length > 0
      Notify.error 'You must specify an email'
      
    else
      Accounts.forgotPassword info, (err) ->
        if err
          console.log 'error in forgot password: ', err
          if err.reason is 'User not found'
            Notify.error 'Unknown email'
          else
            Notify.error 'Failed to send forgot password...'
        else
          Notify.success 'Reset email sent'
