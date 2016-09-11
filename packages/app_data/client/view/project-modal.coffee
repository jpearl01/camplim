modalTemplate = Template.ModalBox.renderAs 'projectModal'

modalTemplate.profiles [ 'ModalBox' ]

modalTemplate.helpers
  $options: this:true

  modalHeaderData: ->
    headerTitle: 'Create Project'

  modalBody: 'project'
  modalBodyData: ->
    editmode: {get: (-> true), set: (->)}
    thingId : ''
    useEditButtons: false
    titleClass: 'hidden'
    fieldContainerClass: 'col-sm-10'
    thing: @getThing()
    inputSelector: 'CIE'

  modalFooterData: ->
    parentData: @data


modalTemplate.functions
  $options: this:true
  getThing: ->
    @template.newThing ?= new Meteor.$things.project
    return @template.newThing
