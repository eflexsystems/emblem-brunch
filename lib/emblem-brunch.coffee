sysPath = require 'path'
fs = require 'fs'
jsdom = require 'jsdom'
emblem = require('emblem').default

module.exports = class EmblemCompiler
  brunchPlugin: yes
  type: 'template'
  extension: 'emblem'
  pattern: /\.(?:emblem)$/

  setup: (@config) ->
    @templateCompiler = require(@config.files.templates.paths.templateCompiler)

  constructor: (@config) ->
    if @config.files.templates?.paths?
      @setup(@config)
    null

  compile: (data, path, callback) ->
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
      filename  = splitPath[splitPath.length - 1]
      splitName = filename.split('~')

      if splitName.length > 1
        prefixes = splitName.slice(0, splitName.length-1)
        filename = prefixes.join('/') + '/' + splitName[splitName.length-1]

      input   = emblem.compile(data)
      content = @templateCompiler.precompile(input, false)
      result  = "Ember.TEMPLATES[#{JSON.stringify(filename)}] = Ember.Handlebars.template(#{content});module.exports = module.id;"

    catch err
      error = err
    finally
      callback(error, result)

