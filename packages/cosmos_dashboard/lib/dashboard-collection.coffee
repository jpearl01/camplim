# use one collection and make the 'Dashboard' info a document with order:0 and exclude it...
# make anything with an order < 1 be excluded. then, we can put entry/users in there too.
# then it's just one collection for:
#  1. the dashboard info like title and footer
#  2. the contexts listed in the header (id, name, default location, ...)
#  3. the single context info in current sidebar (menus/items for sidebar)
#  4. the hidden contexts like entry/users with order:-1 and order:-2
Dashboard =
  if Meteor.hoard?
    Meteor.hoard 'dashboard'
  else
    new Mongo.Collection 'dashboard'

disallow = -> false
Dashboard.allow insert:disallow, update:disallow, remove:disallow
