# Cosmos Navigator Matrix  [![Build Status](https://travis-ci.org/elidoran/cosmos-navigator-matrix.svg?branch=master)](https://travis-ci.org/elidoran/cosmos-navigator-matrix)

Add reactive/non-reactive matrix storage.

Matrix params are like query params except they come after a semi-colon within a path part. For example: `/blah;one=1&two=2/bleh`.

Note: this only adds the functions for handling storage, retrieval, and comparison of the matrix values. It doesn't analyze the location to extract the matrix params from it.

## Install

    $ meteor add cosmos:navigator-matrix


## API

### Nav.matrix

Access matrix values in a non-reative way in an object `matrix` on the Nav object.

```coffeescript
# the item path part has a color matrix param
itemColor = Nav.matrix.item.color
```


### Nav.getMatrix(string, string)

Get a matrix value in a reactive way by its group name and the value name.

```coffeescript
# the item path part has a color matrix param
value = Nav.getMatrix 'item', 'color'
```


### Nav.addMatrix(string, object)

Add new matrix values with their group name and an object of values. This overrides previous values for the keys but does not remove other key/value pairs.

```coffeescript
groups =
  group1:
    some: 'value'
    an: 'other'
  group2:
    second:'group'

Nav.addParams groups
```


### Nav.setMatrix(string, object)

Set new matrix values with their group name and an object of values. This removes all current key/value pairs and then adds these new ones.

```coffeescript
groups =
  group1:
    one: 'value'
    group: 'first'
  group2:
    two: 'value'
    group: 'second'

Nav.setMatrix groups

groups =
  group1:
    group: 'one'
  group2:
    group: 'two'

Nav.setMatrix groups

# these will return undefined. They were cleared by the second setParams call.
value = Nav.getMatrix 'group1', 'one'
value = Nav.getMatrix 'group2', 'two'

# these will return the values
one = Nav.getMatrix 'group1', 'group'
two = Nav.getMatrix 'group2', 'group'
```


### Nav.matrixEquals(string, string, value)

Reactively compare the matrix group's value.

```coffeescript
if Nav.matrixEquals 'item', 'color', 'blue'
  # then do something
else # do something else
```


## MIT License
