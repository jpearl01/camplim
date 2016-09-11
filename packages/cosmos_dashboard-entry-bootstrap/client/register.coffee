trim = (string) -> if string?.length > 0 then string.replace(/^\s*|\s*$/g, "")

Template.register.events

  'submit #registerForm': (event, template) ->

    event.preventDefault()

    name = trim template.find('#name').value
    unless name?.length > 0 #Match.test name, Is.nonEmptyString
      Notify.error 'You must specify a name'
      errors = true

    email = trim template.find('#email').value
    unless email?.length > 0
      Notify.error 'You must specify an email'
      errors = true

    password = template.find('#password').value
    unless password?.length >= 8
      Notify.error 'You must specify a password at least 8 characters long.'
      errors = true

    if not errors?
      info =
        email: email
        password: password
        profile:
          name: name

      Accounts.createUser info, (err) ->
        if err
          # Inform the user that account creation failed
          console.log 'user creation failed: ', err
          # TODO: explaaaaaain to the user
          Notify.error 'Unable to create your account'
        else # success
          Nav.setLocation '/'
