
Template.CamplimFooter.onCreated -> @wishValue = new ReactiveVar

Template.CamplimFooter.helpers
  hasWish: -> Template.instance().wishValue.get()?.length > 0

Template.CamplimFooter.events

  'keyup textarea': (event, template) ->
    input = $(event.target)
    value = input.val()
    template.wishValue.set value

  'click #wish-btn': (event, template) ->

    wish = template.wishValue.get()

    if wish?.length > 0

      input = template.find('#wish')
      input = $(input)

      Meteor.call 'sendWish', wish, (error, result) ->
        if error?
          console.log 'Error sending wish: ',e
          Notify.error 'There is trouble sending your wish. Please, retry.'
        else
          input.val ''
          template.wishValue.set ''
          Notify.success 'Wish Sent. Thank you'
