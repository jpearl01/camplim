# Navigator lasimii

Simplified routing scheme with set URL param format.

Format (where the name comes from):
   /layout/sidebar/menu/item/id?

The values are mapped to a render call activating the main template (layout) and passing the other values as its data to change dynamic templates within the main template.

Render is controlled via *cosmos:navigator-blaze*. It uses `addView()` instead of `setView()` to allow retaining other active views.

Redirect '/' to a default location via `Nav.setDefault()`.

I use this for dashboard apps with contexts in the header which change the sidebar when clicked. The menu represents groups of menu items. The item is the specific menu item active. The template rendered to the main area is a combination of the menu and item names.

## Install

    $ meteor add cosmos:navigator-blaze


## Usage

1. set default location
2. make a layout template
3. make dynamic templates in layout named: sidebar, menu, and item.

### How to set the default location

Lasimii will forward the browser to the default location when the location is '/'.

```coffeescript
# this will load the 'dashboard' template as the layout
# for the 'user' sidebar menu (has multiple menu groups)
# and the 'profile' menu group
# and the 'emails' menu item
# which will render template ProfileEmails into the main area.
nav.setDefault '/dashboard/user/profile/emails'
```

### How to make the layout template

It's a standard Meteor Blaze template, nothing special.


### How to make the dynamic templates

Use the standard Meteor Blaze `Template.dynamic template=name`.

Name them: sidebar, menu, and item.


### What about the id?

When displaying a specific thing you can specify the ID as the last url part.

For example, to display order #12345: `/dashboard/orders/history/view/12345`


## Access params

All five of the named parts are available as params via both reactive and non-reactive ways. 

```coffeescript
# get a param in a non-reactive way
id = Nav.param.id

# get a param reactively
id = Nav.getParam 'id'
```

## Why the name?

Uses the first letters of the names of the template parts: la + si + m + i + i.

## MIT License
