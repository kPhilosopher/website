#!/usr/bin/env phantomjs

# Runs a Jasmine Suite from an html page
# @page is a PhantomJs page object
# @exit_func is the function to call in order to exit the script

class PhantomJasmineRunner
  constructor: (@page, @exit_func = phantom.exit) ->
    @tries = 0
    @max_tries = 10

  get_status: -> @page.evaluate(-> consoleReporter.status)

  terminate: ->
    switch @get_status()
      when "success" then @exit_func 0
      when "fail" then @exit_func 1
      else @exit_func 2

# Script Begin
if phantom.args.length == 0
  console.log "Need a url as the argument"
  phantom.exit 1

tap = phantom.args[1] is 'tap'

page = new WebPage()

runner = new PhantomJasmineRunner(page)

page.onError = (msg) ->
  console.error "\x1B[31m#{msg}\x1B[0m"
  runner.exit_func 2

# Don't supress console output
page.onConsoleMessage = (msg) ->
  # Terminate when the reporter singals that testing is over.
  # We cannot use a callback function for this (because page.evaluate is sandboxed),
  # so we have to *observe* the website.
  if msg is "ConsoleReporter finished"
    runner.terminate()

  if /^##tap/.test msg
    console.log msg if tap
  else unless tap
    console.log msg

address = phantom.args[0]

if phantom.args[1]? and phantom.args[1] isnt 'tap'
  address += "?spec=#{encodeURIComponent phantom.args[1..].join(' ')}"

page.open address, (status) ->
  if status != "success"
    console.log "can't load the address!"
    phantom.exit 1

  # Now we wait until onConsoleMessage reads the termination signal from the log.
