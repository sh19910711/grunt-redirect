describe "T001: Command Spec", ->
  _    = require "underscore"
  fs   = require "fs"
  glob = require "glob"

  # normalize path
  get_path = (path)->
    "#{__dirname}/#{path}"

  # remove output files
  remove_output_files = ()->
    list = glob.sync(
      get_path "tmp/**/*.txt"
    )
    _(list).each (path)->
      fs.unlink path

  before ->
    fs.mkdirSync get_path "tmp" unless fs.existsSync "tmp"
    remove_output_files()

    # define run function
    exec = require("child_process").exec
    @run_grunt = (gruntfile_path, callback)->
      exec(
        "grunt redirect --gruntfile #{gruntfile_path}"
        ()->
          callback.apply(this, arguments)
      )

  afterEach ->
    remove_output_files()

  it "A001: grunt redirect", (done)->
    gruntfile_path = get_path "mocks/t001_a001_gruntfile.coffee"
    @run_grunt gruntfile_path, (error, stdout)=>
      stdout.should.include "All done."
      done() unless error

  it "A002: grunt redirect (failed to overwrite)", (done)->
    gruntfile_path = get_path "mocks/t001_a002_gruntfile.coffee"
    @run_grunt gruntfile_path, (error, stdout)=>
      stdout.should.include "All done."
      @run_grunt gruntfile_path, (error, stdout)=>
        stdout.should.include "File is found"
        done() if error

