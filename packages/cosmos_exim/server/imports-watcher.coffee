# instead of uploading a file to the server, for now, have them put the file on the server in the folder
# then, our watcher sees it and adds it to the collection as an available file for importing
# watchers are sketchy, but, if they repeat, it'll fail to add extras to the collection, so it works out.
# then a user must select the file from the files collection for the import op

# TODO: need to only do this on the master process...

Cluster.startupMaster ->
  # console.log 'i am creating a watcher...',Meteor.settings

  watcher = new (Npm.require 'watch.io') delay: (Meteor.settings.importWatcherDelay ? 400) # 400ms ignores duplicates

  watcherDir = Meteor.settings.importDir

  unless watcherDir?
    # we want to use private/exim/import in dev
    # can we use the same as the default in a production bundle?
    pwd = process.cwd()
    # if in dev, strip off the .meteor stuff
    pwd = pwd.replace '.meteor/local/build/programs/server', ''
    # TODO: find out where we end up in production, hopefully, it's a normal pwd
    watcherDir = pwd + 'private/exim/import'

  # NOTE: using oncreate doesn't work... so, using onchange instead
  watcher.on 'change', (type, filepath, stats) ->

    # console.log 'watcher[%s] %s  %j',type, filepath, stats

    # `watch.io` includes absolute path instead of filename.
    # so, strip off `watcherDir` plus the slash in front of filename
    filename = filepath[watcherDir.length+1...]

    # only process create and update events.
    if (type is 'create' or type is 'update') and filename[0] isnt '.'

      eximFile = EximFiles.findOne path:filepath
      unless eximFile?
        EximFiles.insert
          type: 'import'
          path: filepath      # used elsewhere to locate the file for reading
          name: filename      # used to refer to file, and when reading file
          mtime: stats.mtime  # metadata: modified time
          size: stats.size    # metadata: file size
      else # update it's date
        EximFiles.update {_id:eximFile._id}, $set: mtime:stats.mtime, size:stats.size

  Meteor.startup -> watcher.watch watcherDir
