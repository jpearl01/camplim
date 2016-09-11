Meteor.$publishRecents = (name, filter, options) ->

  options ?= limit: 10, sort: {lastVisit: -1}

  pubName = "recent-#{name}"

  Meteor.publish pubName, (options) ->
    # console.log 'recents publish ',pubName
    sub = this
    handles = {}

    filter ?= {}
    filter.userId = @userId

    # filter must contain either `from` or `collection`
    unless (filter.from? or filter.collection? or name is 'all')
      filter.collection = name

    unless (not options?.limit?) or 0 > options.limit <= 10
      options.limit = 10

    # console.log '  userId:',this.userId
    # console.log '  name:',name
    # console.log '  filter:',filter

    handle = Meteor.$db.recents.find filter, options
      .observeChanges
        added: (id, fields) ->
          # console.log 'added:',id,fields
          collection = Meteor.$db[fields.collection]
          cursor = collection.find {_id:fields.refId}
          handles[id] =
            Mongo.Collection._publishCursor cursor, sub, fields.collection#name
          sub.added 'recents', id, fields # pubName first arg?

        changed: (id, fields) ->
          # console.log 'changed:',id,fields
          sub.changed 'recents', id, fields # pubName first arg?

        removed: (id) ->
          handles[id].stop() if handles?[id]?
          sub.removed 'recents', id # pubName first arg?

    sub.ready()

    sub.onStop -> handle.stop()
