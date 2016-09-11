# Cosmos Navigator Blaze [![Build Status](https://travis-ci.org/elidoran/cosmos-navigator-blaze.svg?branch=master)](https://travis-ci.org/elidoran/cosmos-navigator-blaze)

Blaze View rendering control.

May specify a layout name and data values to go with it.

The data values may be for dynamic templates within the layout template.

To ensure the proper order of `onDestroyed()` and `onCreated()` listeners the data values provided are first set to null in the `ReactiveDict` for the layout. Then, their actual values are set. The first, *view destroy*, step causes the `onDestroyed()` listeners to run. The second, *view create*, step causes the `onCreated()` listeners to run.

Also, when part of the navigator phasor run the above two steps will be separated by a step which changes the route parameters, query parameters, and hash. This way, it prevents having autorun blocks run when the values change and trigger a rerender of views which are about to be destroyed. It also prevents the opposite, changing the values *after* the render which causes the views to render first with the wrong values.

So, with these two functionalities combined, things occur like this:

1. changing view data is set to null in the layout's ReactiveDict.
2. the views referenced by them are destroyed which triggers the `onDestroyed()` listeners.
3. the destroyed views stop their autorun blocks so they won't run with the new values.
4. the param/query/hash values are changed. These don't trigger views or autoruns they shouldn't because those were destroyed in #1-#3.
5. the view data is set to their new values in the layout's ReactiveDict
6. the new views are created and run their `onCreated()` listeners
7. the new param/query/hash values are available to the new views.
8. new autorun blocks may use the new values as well

Note, this is usable without the rest of cosmos navigator packages. On its own, it exports a variable `Views` with all the same functions. It also does the *view destroy* and *view create* steps in sequence to solve the problems described above. To allow changing values in between those two steps you may specify a *between* function which it will run between the two steps.

## Install

    $ meteor add cosmos:navigator-blaze


## Features

1. may use at any time to change views
2. may change more than one view at a time by specifying more than one layout object info to `addView()` or `setView()`
3. may specify where to insert each layout using selectors
4. may specify a default target for all layouts as well as specifying a default target *per layout*. This avoids the need to specify the target every time and easily configures the common case where each layout is rendered into a *main* container.
5. maintains proper order for destroying views and stopping their autoruns before changing values and creating new views
6.

## Solve Problems

Created to solve specific problems with controlling Blaze templates.

### Problem 1: Order of Reactive Changes

TODO: show sample output of template listeners and autorun blocks when changing values in a ReactiveDict providing data.

...

### Problem 2: Multiple Layouts

When there is a single container which all layouts are rendered into, there can only be one layout active at a time.

Navigator Blaze allows specifying a target container for each layout, both at the time of the call, and, when configuring default targets for each layout, or all layouts.

This allows a flexibility in creating complicated application views and changing parts of the view at a time.

TODO: show a template hierarchy with multiple targets and how to change them at once and separately.




## API

### Nav.addView(object)

The view info provided in the object is used to display the views. If they are already displayed then their values will be changed with the new ones. All other views remain as they are.

```coffeescript
Nav.addView
  # top level keys are considered layout names with their values as the view info
  dashboard:
    # if the default target is already 'body', then this `target` is unnecessary
    # if the default target for layout 'cart' is set, then this is unnecessary
    target: 'body' # could be an id selector like: '#main'
    # if these keys are dynamic template names then they'
    # will render a templates with the specified names
    # otherwise, these values are available in the data scope of the dashboard template
    header: 'dheader'
    sidebar: 'usermenu'
    main: 'useroptions'
```


### Nav.setView(object)

This is the same as `Nav.addView()` except all current views are cleared first. Then, the specified view info is used to display only those views.


### Nav.clearViews([name]*)

When no layout names are specified then all views are removed.

May specify one or more names as strings.

```coffeescript
# clears them all
Nav.clearViews()

# clears only the one view
Nav.clearViews 'featureUpdate'

# clears all three views
Nav.clearViews 'adblock', 'summary', 'offer'
```


## MIT License
