# Cosmos Finders Profile

Adds data property finders which avoid unnecessary dependencies.

Any profile function can use the finders, which are put onto the template instance, to search for any properties.

## Install

```
meteor add cosmos:blaze-finders-profile
```



## API

### findProp(key, defaultValue, directValue, limit)

Searches up the hierarchy to find the property in a data context.

Args:

1. key - a string, the key for the data property
2. defaultValue - the default value to return when not found in any data contexts
3. directValue - when used in a helper a value may be provided directly to the helper in the template
4. limit - a number, the maximum data contexts to search up the hierarchy, defaults to 5

### findProps(key, target, limit)

Searches up the hierarchy to find the property in a data context, just like `findProp()`.

Searches for multiple values at once and accepts defaults for all, some, or none via a `target` object.

Args:

1. keys - an array of strings, each element is a key for a data property
2. target - an object, found key/value pairs are set into it. Default values may be provided by setting the key/value pairs in the target option before calling findProps().
3. limit - a number, the maximum data contexts to search up the hierarchy, defaults to 5

### Template.makeHelper(key, defaultValue, limit)

Makes a helper function using findProp().

It accepts the same args as findProp() except directValue. The returned helper function accepts the directValue.

For example:

```coffeescript
Template.someTemplate.helpers
  # searches for `value` up the hierarchy
  value: Template.makeHelper 'value', 'NO VALUE!'
```
