Meteor.$fn.addRecentMethod = (type, recentName, collectionName) ->
  methods = {}
  methods['recent-' + recentName] = (id) ->
    if this.userId?
      recent =
        refId:id
        userId:this.userId
        from:type
        name:recentName
        collection:collectionName

      Meteor.$db.recents.upsert recent, {$setOnInsert:recent,$set:lastVisited:new Date()}

  Meteor.methods methods
