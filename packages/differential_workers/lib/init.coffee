Monq = Npm.require("monq")(process.env.MONGO_URL)

withJobs = (cb) ->
  _.each global, (val, key) ->
    cb(val, key) if (key[-3...] is "Job") and key isnt "Job"
    # cb(val, key) if s.endsWith(key, "Job") and key isnt "Job"


Cluster.startupMaster ->
  count = Jobs.update status: "dequeued",
    $set: status: "queued"
  , multi: true
  Cluster.log "Requeued #{count} jobs."

  unless Meteor.settings?.workers?.cron?.disable
    SyncedCron.options =
      log: Meteor.settings?.workers?.cron?.log
      utc: true
      collectionName: "scheduler"

    withJobs (val, key) ->
      if global[key].setupCron?

        SyncedCron.add
          name: "#{key} (Cron)"
          schedule: global[key].setupCron
          job: ->
            Job.push new global[key]

    SyncedCron.start()


Cluster.startupWorker ->
  Meteor.methods
    handleJob: (job) -> #Job.handler job

      this.userId = if job?.userId? then job.userId else null

      # Instantiate approprite job handler
      className = job._className
      handler = new global[className](job)

      _ex = null

      # quick hack to allow asynchronous op's
      if handler.handleJob.length > 0
        # still wrap to catch error in beforeJob()
        try
          handler.beforeJob()

          # call and pass the wrapped callback
          handler.handleJob Meteor.bindEnvironment (error, result) ->
            # callback error, result
            # call afterJob in the callback, with error if it exists...
            handler.afterJob error

        catch error
          Cluster.log "Error in #{className} handler:\n", _ex
          handler.afterJob error
          # callback error
          throw error
      else
        try
          # Before hook
          handler.beforeJob()

          # Handle the job
          result = handler.handleJob()
          # Forward results to monq callback
          #callback null, result
          return result

        catch ex
          _ex = ex
          Cluster.log "Error in #{className} handler:\n", _ex
          # callback ex
          throw ex

        finally
          # After hook
          handler.afterJob _ex

  monqWorkers = Meteor.settings?.workers?.count or 1
  i = 0
  while i < monqWorkers
    i++
    Meteor.setTimeout ->
      worker = Monq.worker ["jobs"]

      withJobs (val, key) ->
        handlers = {}
        # handlers[key] = Meteor.bindEnvironment Job.handler
        handlers[key] = Meteor.bindEnvironment (job, done) -> Meteor.call 'handleJob', job, done
        worker.register handlers

      worker.on "complete", Meteor.bindEnvironment (data) ->
        Jobs.remove "params._id": data.params._id

      worker.start()
    , 100 * i

  Cluster.log "Started #{monqWorkers} monq workers."
