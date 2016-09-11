# Cosmos Navigator Phasor Array  [![Build Status](https://travis-ci.org/elidoran/cosmos-navigator-phasor-array.svg?branch=master)](https://travis-ci.org/elidoran/cosmos-navigator-phasor-array)

Implement [Navigator Phasor](http://github.com/elidoran/cosmos-navigator-phasor) with an array.

The `this` in each function is the object passed to `Nav.phasor.run(object)`.

A function can stop the execution by returning `false`.

When adding a function to a phase it becomes the first function in that phase.

## Install

    $ meteor add cosmos:navigator-phasor-array


## Usage

```coffeescript
fn = ->
  if this.someValue then this.newValue = 'blah'
  else false # false causes the run() to stop

Nav.phasor.add id:'phase id', fn:fn
```

## MIT License
