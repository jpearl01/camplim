Meteor.publish 'ImportMaps', () -> ImportMaps.find()
# not doing the `creating` thing..
# $or: [
#   {creating: $exists:false}
#   {creating: this.userId} # not the right place for this. don't want them using an incomplete map...
# ]
# Meteor.publish 'ExportMaps', () -> ExportMaps.find $or: [
#   {creating: $exists:false}
#   {creating: this.userId}
# ]

Meteor.publish 'ImportMap', (id) -> ImportMaps.find _id:id
# Meteor.publish 'ExportMap', (id) -> ExportMaps.find _id:id

Meteor.publish 'ImportFiles', -> EximFiles.find type:'import'
# Meteor.publish 'ExportFiles', -> EximFiles.find type:'export'

# both queued and processing status
Meteor.publish 'PendingImports', -> EximOps.find type:'import', status:{$ne:'completed'}, userId:this.userId
# Meteor.publish 'PendingExports', -> EximOps.find type:'export', status:'pending', userId:this.userId

Meteor.publish 'CompletedImports', -> EximOps.find type:'import', status:'completed', userId:this.userId
# Meteor.publish 'CompletedExports', -> EximOps.find type:'export', status:'completed', userId:this.userId
