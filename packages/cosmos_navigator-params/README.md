# Cosmos Navigator Params  [![Build Status](https://travis-ci.org/elidoran/cosmos-navigator-params.svg?branch=master)](https://travis-ci.org/elidoran/cosmos-navigator-params)

Add reactive/non-reactive param storage.

Note: this only adds the functions for handling storage, retrieval, and comparison of the param values. It doesn't analyze the location to extract the params from it.


## Install

    $ meteor add cosmos:navigator-params


## API

### Nav.params

Access param values in a non-reative way in an object `params` on the Nav object.


### Nav.getParam(string)

Get a param value by its name in a reactive way.

```coffeescript
value = Nav.getParam 'theName'
```


### Nav.addParams(object)

Add new param values with an object. This overrides previous values for the keys but does not remove other key/value pairs.

```coffeescript
newStuff =
  some: 'value'
  an: 'other'

Nav.addParams newStuff
```


### Nav.setParams(object)

Set new param values with an object. This removes all current key/value pairs and then adds these new ones.

```coffeescript
firstStuff =
  some: 'value'
  an: 'other'

Nav.setParams firstStuff

secondStuff =
  diff: 'values'
  than: 'before'

Nav.setParams secondStuff

# this will return undefined. It was cleared by the second call.
some = Nav.getParam 'some'

# this will return 'values'
diff = Nav.getParam 'diff'
```


### Nav.paramEquals(string, value)

Reactively compare the value.

```coffeescript
if Nav.paramEquals 'some', 'value'
  # then do something
else # do something else
```


## MIT License
