# Cosmos Navigator Query  [![Build Status](https://travis-ci.org/elidoran/cosmos-navigator-query.svg?branch=master)](https://travis-ci.org/elidoran/cosmos-navigator-query)

Add reactive/non-reactive query storage.

Note: this only adds the functions for handling storage, retrieval, and comparison of the query values. It doesn't analyze the location to extract the query values from it.


## Install

    $ meteor add cosmos:navigator-query


## API

### Nav.query

Access query values in a non-reative way in an object `query` on the Nav object.


### Nav.getQuery(string)

Get a query value by its name in a reactive way.

```coffeescript
value = Nav.getQuery 'theName'
```


### Nav.addQuery(object)

Add new query values with an object. This overrides previous values for the keys but does not remove other key/value pairs.

```coffeescript
newStuff =
  some: 'value'
  an: 'other'

Nav.addQuery newStuff
```


### Nav.setQuery(object)

Set new query values with an object. This removes all current key/value pairs and then adds these new ones.

```coffeescript
firstStuff =
  some: 'value'
  an: 'other'

Nav.setQuery firstStuff

secondStuff =
  diff: 'values'
  than: 'before'

Nav.setQuery secondStuff

# this will return undefined. It was cleared by the second call.
some = Nav.getQuery 'some'

# this will return 'values'
diff = Nav.getQuery 'diff'
```


### Nav.queryEquals(string, value)

Reactively compare the value.

```coffeescript
if Nav.queryEquals 'some', 'value'
  # then do something
else # do something else
```


## MIT License
