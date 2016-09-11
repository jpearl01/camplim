for name in [ 'collaborators', 'members' ]
  Meteor.$fn.makePublication name
  Meteor.$fn.makeSearch name

Meteor.publish 'MyMember', () -> Meteor.$db.members.find _id:this.userId

Meteor.$publishRecents 'people', from:'people'

Meteor.$publishRecents 'members'
Meteor.$publishRecents 'collaborators'
