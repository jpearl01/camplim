modalTemplate = Template.ModalBox.renderAs 'collaboratorModal'

modalTemplate.profiles [ 'ModalBox' ]

modalTemplate.helpers
  $options: this:true

  modalHeaderData: ->
    headerTitle: 'Create Collaborator'

  modalBody: 'collaborator'
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
    # addIndex: '5'
    # cancelIndex: '6'


modalTemplate.functions
  $options: this:true
  getThing: ->
    @template.newThing ?= new Meteor.$things.collaborator
    return @template.newThing
