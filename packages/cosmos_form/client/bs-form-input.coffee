Template.profiles

  $options: this:true

  BootstrapFormInput:

    helpers:

      label: ->
        label = @template.findKey 'label'
        unless label?
          label = @template.findKey 'name'
          if label? then label = label[0].toUpperCase() + label[1...]
        return label

      type: Template.$makeHelper 'type', 'text'

      typeMarker: Template.$makeHelper 'typeMarker', 'TI'

      groupClass: Template.$makeHelper 'groupClass', 'form-group', 3

      labelClass: Template.$makeHelper 'labelClass', 'control-label col-sm-2'

      fieldContainerClass: Template.$makeHelper 'fieldContainerClass', 'col-sm-8'

      # fieldClass: Template.$makeHelper 'fieldClass'

      inputClass: Template.$makeHelper 'inputClass', 'form-control'

      inputSelector: Template.$makeHelper 'inputSelector', 'CIE KIE'

      useAddonSuffix: Template.$makeHelper 'useAddonSuffix', true # false

      addonClass: Template.$makeHelper 'addonClass', 'input-group-addon'

      addonSuffixContent: Template.$makeHelper 'addonSuffix', 'suffix'

      removeClass: Template.$makeHelper 'removeClass', 'form-control-feedback glyphicon'

      removeIconClass: Template.$makeHelper 'removeIconClass', 'glyphicon-remove text-default'
      #   if @template.errorVar.get()? then 'glyphicon-remove'
      #   else if @template.successVar.get() then 'glyphicon-ok'
      #   else ''

      errorClass: Template.$makeHelper 'errorClass', 'has-error col-sm-9 col-sm-offset-2'

      autocomplete: Template.$makeHelper 'autocomplete', 'off'

      editIconClass: Template.$makeHelper 'editIconClass', 'text-primary glyphicon glyphicon-pencil'

      staticFieldClass: Template.$makeHelper 'staticFieldClass', 'form-control-static'

      useChangeButton: Template.$makeHelper 'useChangeButton', true
