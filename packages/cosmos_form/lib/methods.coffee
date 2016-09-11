
# server only??
if Meteor.isServer
  Meteor.methods
    saveThing: (thing) ->
      # console.log 'saving thing:',thing
      if thing.isModified()
        if thing.validate() then thing.save()
        else
          thing.throwValidationException()
      else
        thing._id
