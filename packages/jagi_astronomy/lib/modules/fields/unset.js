var proto = Astro.BaseClass.prototype;

proto.unset = function(/* arguments */) {
  var doc = this;
  var Class = doc.constructor;
  var event;
  var modifierFieldValue;

  fields = Array.prototype.slice.call(arguments)

  // must assume at least one value in fieldValues is defined

  // Trigger the "beforeChange" event handlers.
  event = new Astro.Event('beforeChange', {
    fields: fields,
    operation: 'unset'
  });
  event.target = doc;
  Class.emitEvent(event);

  // If an event was prevented from the execution, then we stop here.
  if (event.defaultPrevented) {
    return;
  }

  // Trigger the "beforeUnset" event handlers.
  event = new Astro.Event('beforeUnset', {
    fields: fields
  });
  event.target = doc;
  Class.emitEvent(event);

  // If an event was prevented from the execution, then we stop here.
  if (event.defaultPrevented) {
    return;
  }

  // Set default options of the function.
  options = _.extend({
    cast: false,
    modifier: true,
    mutable: false
  }, options);

  // An indicator for detecting whether a change of a value was necessary.
  var changed = false;

  _.each(fields, function(fieldName) {
    Astro.utils.fields.traverseNestedDocs(
      doc,
      fieldName,
      function(nestedDoc, nestedFieldName, Class, field, index) {
        if (field) {
          // Check whether the field is immutable, so we can not update it and
          // should stop execution.
          if (field.immutable && !options.mutable) {
            var currFieldValue;
            if (_.isUndefined(index)) {
              currFieldValue = nestedDoc[nestedFieldName];
            } else {
              currFieldValue = nestedDoc[nestedFieldName][index];
            }
            if (!doc._isNew && !_.isNull(currFieldValue)) {
              return;
            }
          }

          // If the field has the "transient" flag set to true, then we have to
          // modify options and turn off the "modifier" flag.
          if (field.transient) {
            options.modifier = false;
          }
          //
          // // We are setting a value of a single nested field.
          // if (field instanceof Astro.fields.object) {
          //
          //   // // The value being set has to be an object.
          //   // if (!_.isObject(setValue)) {
          //   //   return;
          //   // }
          //   // // Try casting the value to the proper type.
          //   // if (options.cast) {
          //   //   setValue = field.cast(setValue);
          //   // }
          //   // // Get a plain value of a field for a modifier.
          //   // if (options.modifier) {
          //   //   modifierFieldValue = field.plain(setValue);
          //   // }
          //
          // }
          // // We are setting a value of many nested fields.
          // else if (field instanceof Astro.fields.array) {
          //
          //   // // There are two possiblities. We can try setting entire array or a
          //   // // single array element.
          //   // if (_.isUndefined(index)) {
          //   //
          //   //   // The value being set has to be an array.
          //   //   if (!_.isArray(setValue)) {
          //   //     return;
          //   //   }
          //   //   if (options.modifier) {
          //   //     modifierFieldValue = [];
          //   //   }
          //   //   _.each(setValue, function(v, i) {
          //   //     // Try casting the value to the proper type.
          //   //     if (options.cast) {
          //   //       setValue[i] = field.cast(v);
          //   //     }
          //   //     // Get a plain value of a field for a modifier.
          //   //     if (options.modifier) {
          //   //       modifierFieldValue[i] = field.plain(v);
          //   //     }
          //   //   });
          //   //
          //   // } else {
          //   //
          //   //   // Try casting the value to the proper type.
          //   //   if (options.cast) {
          //   //     setValue = field.cast(setValue);
          //   //   }
          //   //   // Get a plain value of a field for a modifier.
          //   //   if (options.modifier) {
          //   //     modifierFieldValue = field.plain(setValue);
          //   //   }
          //   //
          //   // }
          //
          // }
          // // We are just setting the value.
          // else {
          //
          //   // // Try casting the value to the proper type.
          //   // if (options.cast) {
          //   //   setValue = field.cast(setValue);
          //   // }
          //   //
          //   // // Get a plain value of a field for a modifier.
          //   // if (options.modifier) {
          //   //   modifierFieldValue = field.plain(setValue);
          //   // }
          //
          // }
        } else if (Class) {
          Astro.utils.warn(
            'Trying to set a value of the "' + nestedFieldName +
            '" field that does not exist in the "' + Class.getName() + '" class'
          );
          return;
        }

        // Add modifier.
        if (options.modifier) {
          // if (_.isUndefined(modifierFieldValue)) {
          //   modifierFieldValue = EJSON.clone(setValue);
          // }
          if (nestedDoc instanceof Astro.BaseClass) {
            if (_.isUndefined(index)) {
              changed = nestedDoc._addModifier(
                '$unset', nestedFieldName//, modifierFieldValue
              );
            } else {
              changed = nestedDoc._addModifier(
                '$unset', nestedFieldName + '.' + index//, modifierFieldValue
              );
            }
          // added this because an unsaved thing needs to remove a $set when unset...
          } else if (doc._hasModifier('$set', fieldName)) {
            doc._removeModifier('$set', fieldName)
            changed = true
          } else {
            changed = doc._addModifier('$unset', fieldName/*, modifierFieldValue*/);
          }
        } else {
          // If the "modifier" option is not set it means that we just want a
          // given value to be set without checking if it is possible.
          changed = true;
        }

        // If a value change was not possible, then we stop here.
        if (!changed) {
          return;
        }

        // Set the given value on the document but only if the value has changed.
        if (_.isUndefined(index)) {
          // if (EJSON.equals(nestedDoc[nestedFieldName], setValue)) {
          //   return;
          // }
          // nestedDoc[nestedFieldName] = setValue;
          delete nestedDoc[nestedFieldName]
        } else {
          // if (EJSON.equals(nestedDoc[nestedFieldName][index], setValue)) {
          //   return;
          // }
          // nestedDoc[nestedFieldName][index] = setValue;
          nestedDoc[nestedFieldName].splice(index, 1)
        }
      }
    );
  });

  // If a value change did not take place, then we stop here and the following
  // events will not be triggered.
  if (!changed) {
    return;
  }

  // Trigger the "afterSet" event handlers.
  event = new Astro.Event('afterUnset', {
    fields: fields
  });
  event.target = doc;
  Class.emitEvent(event);

  // Trigger the "afterChange" event handlers.
  event = new Astro.Event('afterChange', {
    fields: fields,
    operation: 'unset'
  });
  event.target = doc;
  Class.emitEvent(event);

};
