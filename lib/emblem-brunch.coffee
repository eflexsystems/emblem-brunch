sysPath = require 'path'
fs = require 'fs'
jsdom = require 'jsdom'

module.exports = class EmblemCompiler
  brunchPlugin: yes
  type: 'template'
  extension: 'emblem'
  pattern: /\.(?:emblem)$/

  setup: (@config) ->
    @window = jsdom.jsdom().createWindow()
    paths = @config.files.templates.paths
    if paths.jquery
      @window.run fs.readFileSync paths.jquery, 'utf8'
    @window.run fs.readFileSync paths.handlebars, 'utf8'
    @window.run fs.readFileSync paths.emblem, 'utf8'
    if paths.ember
      @window.run fs.readFileSync paths.ember, 'utf8'
      @ember = true
    else
      @ember = false

  constructor: (@config) ->
    if @config.files.templates?.paths?
      @setup(@config)
    null

  compile: (data, path, callback) ->

    if not @window?
      return callback "files.templates.paths must be set in your config", {}
    try
      hasInline = data.indexOf(' style') != -1

      if hasInline
        throw new Error("inline css in file at path #{path}")

      path = path
        .replace(new RegExp('\\\\', 'g'), '/')
        .replace(/^app\//, '')
        .replace(/^templates\//, '')
        .replace(/\.\w+$/, '')
      splitPath = path.split('/')
      filename = splitPath[splitPath.length - 1]

      if filename.match(/^template/)
        content = @window.Emblem.precompile @window.Handlebars, data
        result = "module.exports = Handlebars.template(#{content});"
      else
        splitName = filename.split('~')
        if splitName.length > 1
          prefixes = splitName.slice(0, splitName.length-1)
          filename = prefixes.join('/') + '/' + splitName[splitName.length-1]

        content = @window.Emblem.precompile @window.Ember.Handlebars, data
        result = "Ember.TEMPLATES[#{JSON.stringify(filename)}] = Ember.Handlebars.template(#{content});module.exports = module.id;"
    catch err
      error = err
    finally
      callback error, result
