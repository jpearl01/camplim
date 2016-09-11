Recents = Meteor.hoard 'recents',
  transform: (doc) ->
    # console.log "doc transform name[#{doc.name}] from[#{doc.from}] id[#{doc.refId}] coll[#{doc.collection}]]"
    doc[doc.name] = Meteor.$db[doc.collection].findOne _id:doc.refId
    return doc

Recents.allow
  insert: -> false
  update: -> false
  remove: -> false

# TODO:
#  astronomy class?
