modalTemplate = Template.ModalBox.renderAs 'locationModal'

modalTemplate.profiles [ 'ModalBox' ]

modalTemplate.helpers
  $options: this:true

  modalHeaderData: ->
    headerTitle: 'Create Location'

  modalBody: 'location'
  modalBodyData: ->
    editmode: {get: (-> true), set: (->)}
    thingId : ''
    useEditButtons: false
    titleClass: 'hidden'
    fieldContainerClass: 'col-sm-11'
    thing: @getThing()
    inputSelector: 'CIE'

  modalFooterData: ->
    parentData: @data


modalTemplate.functions
  $options: this:true
  getThing: ->
    @template.newThing ?= new Meteor.$things.location
    return @template.newThing
