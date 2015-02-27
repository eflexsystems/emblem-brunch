## emblem-brunch

Adds [Emblem](http://emblemjs.com/) support to [brunch](http://brunch.io).

## Installation

Add `"emblem-brunch": "x.y.z"` to `package.json` of your brunch app.

Pick a plugin version that corresponds to your minor (y) brunch version.

If you want to use git version of plugin, add
`"emblem-brunch": "git+https://github.com/machty/emblem-brunch.git"`.

Download [Emblem](http://emblemjs.com)

## Usage

```coffeescript
exports.config =
  files:
    # ...
    templates:
      precompile: true
      root: 'templates'
      defaultExtension: 'emblem'
      joinTo: 'javascripts/app.js'
      paths:
        templateCompiler: '../../../bower_components/ember/ember-template-compiler'
```

### With Ember

Require templates in your main script.

```coffeescript
require 'templates/application'
require 'templates/index'
```

This will configure `Ember.TEMPLATES` automatically.

## Credits

Based on [handlebars-brunch](https://github.com/brunch/handlebars-brunch) and
[ember-precompiler-brunch](https://github.com/chrixian/ember-precompiler-brunch).
