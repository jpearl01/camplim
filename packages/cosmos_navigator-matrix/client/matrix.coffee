# for both of these the store is two tiered.
# tier1 is the name of the path part
# tier2 is the name of the key in the key/value pair
# For example: /path;key=value
# 'path' is the tier1, 'key' is tier2
# Nav.matrix.path.key = 'value'
# Nav._matrix.path.get('key') = 'value'
Nav.matrix = {}
Nav._matrix = {}

Nav.getMatrix ?= (groupName, valueName) ->
  # if there's a valueName then get the specific value
  if valueName? then @_matrix?[groupName]?.get valueName
  # else return the ReactiveDict for the group name
  else @_matrix[groupName]

Nav.matrixEquals ?= (groupName, valueName, value) ->
  # use ReactiveDict's equals() function
  @_matrix?[groupName]?.equals valueName, value

Nav.addMatrix ?= (groupName, matrix) ->
  # if there's already info stored for this groupName
  if @matrix[groupName]?
    # get both groups, non-reactive and reactive
    group1 = @matrix[groupName]
    group2 = @_matrix[groupName]
    # loop over the key/values given and set them into the groups
    # ReactiveDict.set would loop over it anyway, and, we're looping for the
    # non-reactive store, so, we might as well call set on the ReactiveDict
    # while we're looping
    for key,value of matrix
      group1[key] = value
      group2.set key, value

  else
    # else, just set the values into the non-reactive store
    @matrix[groupName] = matrix
    # and create a new ReactiveDict
    group = @_matrix[groupName] = new ReactiveDict 'Matrix' + groupName
    # and set the values into it
    group.set matrix

Nav.setMatrix ?= (groupName, matrix) ->
  # overwrite the values
  @matrix[groupName] = matrix
  # if the ReactiveDict already exists then clear it
  if @_matrix[groupName]? then @_matrix[groupName].clear()
  # else create a new ReactiveDict
  else @_matrix[groupName] = new ReactiveDict 'Matrix' + groupName
  # then, either way, we call set on the ReactiveDict
  @_matrix[groupName].set matrix
