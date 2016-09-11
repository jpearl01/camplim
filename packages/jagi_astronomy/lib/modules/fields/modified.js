var proto = Astro.BaseClass.prototype;

proto.getModified = function(old) {
  old = old || false;
  var doc = this;
  var Class = doc.constructor;

  doc._clearUnnecessaryModifiers();

  if (doc._id && Class.getCollection()) {
    var originalDoc = Class.findOne(doc._id);
  } else {
    var originalDoc = new Class();
  }

  var modified = {};

  var fields = Class.getFields();
  _.each(fields, function(field, fieldName) {
    if (field.transient) {
      return;
    }
    // If a value differs from the value in the original object then it means
    // that fields was modified from the last save.
    if (!EJSON.equals(originalDoc[fieldName], doc[fieldName])) {
      // Take a value before or after modification.
      var fieldValue;
      if (old) {
        fieldValue = originalDoc[fieldName];
      } else {
        fieldValue = doc[fieldName];
      }

      modified[fieldName] = fieldValue;
    }
  });

  return modified;
};

proto.getModifiedCount = function() {
  if (Meteor.isClient) return doc._hasChanges.get()
}

proto.isModified = function() {
  var doc = this;

  if (Meteor.isServer) {
    // Get a modifier.
    var modifier = doc._getModifiers();
    // If there are any modifiers, then it means that document was modified.
    return _.size(modifier) > 0;
  } else {
    return doc._hasChanges.get() > 0
  }
};

proto.isNotModified = function() {
  return ! this.isModified();
};

// Do Server version which doesn't use a ReactiveVar, just a regular var?
if (Meteor.isClient) {
  Astro.eventManager.on('beforeInit', function(e) {
    doc = this
    doc._isInit = true
    doc._hasChanges = new ReactiveVar(0)
  });

  Astro.eventManager.on('afterInit', function(e) {
    doc = this
    doc._isInit = false
  });

  Astro.eventManager.on('afterChange', function(e) {
    doc = this
    if ( ! doc._isInit) {
      count = doc._hasChanges.get()
      doc._hasChanges.set(count ? (count + 1) : 1)
    }
  });

  Astro.eventManager.on('afterSave', function(e) {
    doc = this
    doc._hasChanges.set(0)
  });
}
