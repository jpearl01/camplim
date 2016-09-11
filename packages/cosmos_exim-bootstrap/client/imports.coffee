theTemplate = Template.ImportPending

theTemplate.onCreated this:true, fn: ->
  @subscribe 'CompletedImports'
  @subscribe 'PendingImports'
  @template.deleting = new ReactiveDict

theTemplate.helpers
  $options: this:true

  queuedImports: -> EximOps.find {status:'queued'}, sort: created:1

  processingImports: -> EximOps.find {status:'processing'}, sort: created:1

  completedImports: -> EximOps.find {status:'completed'}, sort: created:1

  erroredImports: -> EximOps.find {status:'errored'}, sort: created:1

  deleting: (importId) ->
    console.log 'import:',importId
    @template.deleting.get importId

theTemplate.events
  $options: this:true

  'click .delete-button': ->
    console.log 'click delete:',@data._id
    @template.deleting.set @data._id, true

  'click .confirm-delete-button': ->
    importId = @data._id
    console.log 'confirm delete:',importId
    Meteor.call 'removeEximOp', importId, (error, result) =>
      if error?
        console.log 'Error removing:',error
      else
        @template.deleting.delete importId

  'click .cancel-delete-button': ->
    @template.deleting.delete @data._id
    
