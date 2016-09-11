Meteor.publish 'InLocation', (locationId) ->
  console.log 'publish InLocation:',locationId
  unless locationId? then return

  sub = this

  for name in [ 'specimens', 'constructs', 'bacteria' ]
    do (name) ->
      singularName = if name[-1...] is 's' then name[...-1] else name
      if singularName is 'bacteria' then singularName = 'bacterium'
      cursor = Meteor.$db[name].find locationId:locationId
      handle = cursor.observeChanges
        added: (id, fields) ->
          fields.__sourceType = singularName
          sub.added 'InLocation', id, fields

        changed: (id, fields) ->
          sub.changed 'InLocation', id, fields

        removed: (id) ->
          sub.removed 'InLocation', id

      sub.onStop -> handle.stop()

  sub.ready()

  return
