# Cosmos Navigator Phasor  [![Build Status](https://travis-ci.org/elidoran/cosmos-navigator-phasor.svg?branch=master)](https://travis-ci.org/elidoran/cosmos-navigator-phasor)

Direct nav actions in phases.

Add functions to phases and they will be executed when the Navigator location changes.

Add new phases when the standard ones aren't enough, or, to further control the order of execution.

Standard phases:

1. analyze - look at location info to produce derivative info
2. exit - when exiting a location
3. enter - when entering a location
4. before - before the usual groups of "route actions"
5. actions - "route actions", like, rendering and data retrieval
6. after - after the usual groups of "route actions"


## Install

    $ meteor add cosmos:navigator-phasor


## API

### Nav.phasor.add(object)

#### Add a Phase

```coffeescript

# specify the phase via the `id` property.
# with no `before` or `after` property the phase will
# be added last
Nav.phasor.add id:'some phase name'

# add the phase *before* another phase by specifying the `before`
Nav.phasor.add id:'diff phase name', before:'other phase'

# add the phase *after* another phase by specifying the `after`
Nav.phasor.add id:'third phase name', after:'other phase'

# if you specify both before and after the before will be ignored
```

#### Add a Function to a Phase

```coffeescript
fn = -> # some function

# specify the phase via the `id` property.
# specify the function via the `fn` property
Nav.phasor.add id:'phase name', fn:fn
```


### Nav.phasor.run(object)

Executes the functions for each phase in order.

The specified object is provided to each function as an argument or the context.


```coffeescript
context = some:'value'
Nav.phasor.run context
```

## MIT License
