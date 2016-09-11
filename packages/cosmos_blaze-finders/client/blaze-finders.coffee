# search data contexts to find a key, create a dependency on that one context
# does not create a dependency when the key isn't found
Blaze.TemplateInstance::findKey = findKey = (key, defaultValue, limit = 5, directValue) ->

  if directValue then return directValue

  # TODO:
  # consider combining findKey and findKeys by calling findKeys for findKey ...
  #   target = {}
  #   target[key] = defaultValue
  #   findKeys [key], target, limit
  #   return target[key]
  #
  # would require making an object, making an array, doing extra looping work...

  value = defaultValue

  # get the first Blaze.With which has the data in a ReactiveVar
  theWith = Blaze.getView 'with'

  # loop up to `limit` checking each Blaze.With.
  for count in [0...limit]

    # if `theWith` has the key in its ReactiveVar
    if theWith?.dataVar?.curValue?[key]?

      # then get its value by calling get() to trigger a dependency
      value = theWith.dataVar.get()[key]

      # end the loop
      break

    # otherwise, get the next 'with' up the hierarchy
    theWith = Blaze.getView theWith, 'with'

  return value

# search data contexts to find specified keys,
# create a dependency on each context containing a desired key
# does not create a dependency when keys aren't found
# keys are removed from the array whent they are found, any remaining weren't found
Blaze.TemplateInstance::findKeys = (keys, target={}, limit = 5) ->

  # get the first Blaze.With which has the data in a ReactiveVar
  theWith = Blaze.getView 'with'

  # loop up to `limit` checking each Blaze.With.
  for count in [0...limit]

    # get the ReactiveVar from the 'with'
    dataVar = theWith?.dataVar

    # loop over our keys checking if any of them are in this dataVar
    for key,index in keys by -1
      # if `theWith` has the key in its ReactiveVar
      if dataVar?.curValue?[key]?
        # then get its value by calling get() to trigger a dependency
        target[key] = dataVar.get()[key]
        # remove the key from the array because we've got a value for it
        keys.splice index, 1

    # get the next 'with' up the hierarchy
    theWith = Blaze.getView theWith, 'with'

  # all done, return the results
  return target

# combines Template.currentData() and Template.parentData()
# a reactive dependency.
Blaze.TemplateInstance::getData = (count = 0) -> Template.parentData count

# add ability to make a helper function using findData:
# helpers:
#   someProp: Template.$makeHelper 'someProp', 'default value', 3
Template.$makeHelper = (name, defaultValue, limit) ->
  return (directValue) -> findKey.call this, name, defaultValue, limit, directValue
