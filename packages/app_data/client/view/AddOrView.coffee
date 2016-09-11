
Template.profiles

  $options: this:true

  AVE:

    helpers:

      # for the save button in 'add' mode
      useSaveButton: ->
        Nav.paramEquals('menu', @Template.names.singular) and Nav.paramEquals('item', 'add')
      buttonClass: Template.$makeHelper 'buttonClass'

      # from the modal using the AVE stuff...
      headerClass: Template.$makeHelper 'headerClass'
      titleClass: Template.$makeHelper 'titleClass'

      # from cosmos:form's BootstrapFormInput stuff
      fieldContainerClass: ->
        value = @template.findKey 'fieldContainerClass'
        return value ? if Nav.paramEquals('item', 'add') then 'col-sm-10' else 'col-sm-8'

    onCreated:
      subscribeAndRecent: ->
        @template.data.thingVar = @template.thingVar = new ReactiveVar

        # 1. first autorun uses thingId to subscribe and call recent
        @autorun =>
          thingId = @template.findKey 'thingId', Nav.getParam 'id'
          console.log '  1 thingId:',thingId
          if thingId?.length > 0
            @subscribe 'single-' + @Template.names.singular, thingId
            Meteor.call 'recent-' + @Template.names.singular, thingId

        # 2. second autorun uses thingId to get from collection.
        #    this one will run a second time when subscription data arrives
        @autorun =>
          thingId = @template.findKey 'thingId', Nav.getParam 'id'
          console.log '  2 thingId:',thingId
          if thingId?.length > 0
            thing = @collection().findOne _id:thingId
          else # example: new Specimen

            thing = new Meteor.$things[@Template.names.singular]

          # set the thing into our reactive var
          @template.thingVar.set thing

        return

    functions:

      collection: -> Meteor.$db[@Template.names.plural]

      formSave: (error, result) ->
        if error?
          console.log 'save() errored:',error

        else
          console.log 'save() successful. result:',result#._id

          if 'add' is Nav.params.item
            console.log 'we are in ADD so changing to view'
            Nav.to
              combine: params:true
              params: item:'view', id:result
