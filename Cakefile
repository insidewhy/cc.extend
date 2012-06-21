{exec} = require 'child_process'
path   = require 'path'
ake    = require 'cc.ake'

do ake.nodeModulePath

task 'web', 'build ccloader.js for use in websites', (options) ->
  ake.assert 'mkdir -p cc && ccbaker -m -C lib/cc/extend.coffee > cc/extend.js'

task 'clean', 'clean everything generated by build system', (options) ->
  ake.assert "rm -rf `grep '^/' .gitignore | sed 's,^/,,'`"

task 'test', 'test cc.extend', (options) ->
  ake.assert 'ln -sf ../cc test',
    ake.invoke 'web'
    ->
      express = require 'express'
      app     = express.createServer()
      port    = process.env.port or 8013
      app.configure ->
        app.use express.static path.join(process.cwd(), 'test')
      console.log "cc.extend test server listening on: #{port}"
      console.log "please go to http://localhost:#{port}/"
      app.listen port

# vim:ts=2 sw=2