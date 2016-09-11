# Cosmos Navigator Hash  [![Build Status](https://travis-ci.org/elidoran/cosmos-navigator-hash.svg?branch=master)](https://travis-ci.org/elidoran/cosmos-navigator-hash)

Add reactive/non-reactive hash storage.


## Install

    $ meteor add cosmos:navigator-hash


## API

### Nav.hash

Access hash value in a non-reative way on the Nav object.


### Nav.getHash()

Get the hash value in a reactive way.

```coffeescript
value = Nav.getHash()
```


### Nav.setHash(string)

Set new hash value into the reactive var.

```coffeescript
Nav.setHash 'some-hash-value'
```


### Nav.hashEquals(string)

Reactively compare the value.

```coffeescript
if Nav.hashEquals 'value'
  # then do something
else # do something else
```


## MIT License
