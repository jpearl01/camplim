Meteor.startup ->

  Accounts.config
    sendVerificationEmail: true

  nameExistsFor = (user) -> user?.profile?.name?
  nameFor = (user) -> user.profile.name
  enrollUrl = (url) -> url.replace '/#/enroll-account', '/dashboard/entry/enroll/email'
  resetUrl  = (url) -> url.replace '/#/reset-password', '/dashboard/entry/reset/email'
  verifyUrl = (url) -> url.replace '/#/verify-email',   '/dashboard/entry/verify/email'

  # shortcut
  emails = Accounts.emailTemplates

  emails.siteName = 'Camplim'
  emails.from = 'Eli Doran <eli+camplim@elidoran.com>'

  # Enroll email
  emails.enrollAccount.subject = (user) ->
    "Welcome to #{emails.siteName}#{' ' + nameFor user if nameExistsFor user}"

  emails.enrollAccount.text = (user, url) ->
    """
    Hello#{' ' + nameFor user if nameExistsFor user}.

    Your account is now ready for you. Begin here:

      #{enrollUrl url}

    """

  emails.enrollAccount.html = (user, url) ->
    """
    <p>Hello#{' ' + nameFor user if nameExistsFor user}. Your account is now ready for you.</p>
    <p><a href='#{enrollUrl url}'>Begin here</a></p>
    """

  # Reset Password email
  emails.resetPassword.subject = (user) ->
    "#{emails.siteName} Password Reset#{' for ' + nameFor user if nameExistsFor user}"

  emails.resetPassword.text = (user, url) ->
    """
    Hello#{' ' + nameFor user if nameExistsFor user},

    Click the link below to reset your password:

      #{resetUrl url}

      Thank you.

    """

  emails.resetPassword.html = (user, url) ->
    "<p>Please, <a href='#{resetUrl url}'>click here</a> to <em>reset</em> your password.</p>"

  # Verify Email email
  emails.verifyEmail.subject = (user) ->
    "Camplim Email Verification#{' for ' + nameFor user if nameExistsFor user}"

  emails.verifyEmail.text = (user, url) ->
    """
    Hello#{' ' + nameFor user if nameExistsFor user},

    Click the link below to verify your password:

    #{verifyUrl url}

    Thank you.

    """

  emails.verifyEmail.html = (user, url) ->
    "<p>Please, <a href='#{verifyUrl url}'>click here</a> to <em>verify</em> your password.</p>"

  #Email.send
  #  from: 'eli+nexus@elidoran.com'
  #  to: 'eli+testing@elidoran.com'
  #  subject: 'Testing email send from MeteorJS'
  #  html: '<h1>Testing</h1><p>this is a test.</p>'
