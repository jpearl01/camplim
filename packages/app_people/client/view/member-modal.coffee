modalTemplate = Template.ModalBox.renderAs 'memberModal'

modalTemplate.profiles [ 'ModalBox' ]

modalTemplate.helpers
  $options: this:true

  modalHeaderData: ->
    headerTitle: 'Create Member'

  modalBody: 'member'
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
    # addIndex: '2'
    # cancelIndex: '3'


modalTemplate.functions
  $options: this:true
  getThing: ->
    @template.newThing ?= new Meteor.$things.member
    return @template.newThing
