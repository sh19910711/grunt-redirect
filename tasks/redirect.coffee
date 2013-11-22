#
# grunt-redirect
# https://github.com/sh19910711/grunt-redirect
#
# Copyright (c) 2013 Hiroyuki Sano
# Licensed under the MIT License.
#
module.exports = (grunt) ->
  _     = require("underscore")
  async = require("async")
  fs    = require("fs")

  
  # redirect options
  flags =
    stdout: true
    stderr: false
    overwrite: true

  
  # get filenames from options
  get_files = get_files = (options) ->
    if typeof options is "object"
      keys = _(options).keys()
      return _(keys).filter((key) ->
        typeof key is "string" and key.length > 0
      )
    throw new Error("E001: Unknown files option")

  
  # get arguments from command text
  get_args = get_args = (text) ->
    args_text = text.match(/\s(.*)/)[1]
    args = args_text.split(" ")
    args

  
  # get commands from options
  get_commands = get_commands = (options) ->
    # split into command and args
    keys = _(options).keys()
    _(keys).reduce((commands, key) ->
      obj = {}
      command_text = options[key]
      # has args
      if /\s/.test(command_text)
        command = command_text.match(/(.*)\s/)[1]
        args = get_args(command_text)
        obj[key] =
          command: command
          args: args
      # command only
      else
        obj[key] =
          command: command_text
          args: []
      _(commands).extend obj
      commands
    , {})

  
  # to boolean
  to_boolean = to_boolean = (x) ->
    !!x

  
  #
  # main task
  # 
  redirect_task_func = redirect_task_func = ->
    done_callback = @async()
    options       = @data
    commands      = get_commands(options.files)
    files         = get_files(options.files)
    
    # extend flags
    _(flags).extend @options()
    
    # execute command
    exec_command = exec_command = (filename, callback) ->
      command = commands[filename]
      grunt.util.spawn
        cmd: command.command
        args: command.args
      , (error, result, code) ->
        res = to_boolean(error)
        unless res
          grunt.log.writeln command.command + " > " + filename + ": OK"
          
          # set written data
          write_body = ""
          write_body += result.stdout if flags.stdout
          write_body += result.stderr if flags.stderr
          
          # check to exist the file if flags.overwrite equals false
          throw new Error("E003: File is found (#{filename})") if fs.existsSync(filename)  unless flags.overwrite
          fs.writeFileSync filename, write_body
        else
          grunt.log.writeln "#{command.command} > #{filename}: NG"
        callback res


    
    #
    # run command each file
    # 
    functions = _(files).map((filename) ->
      exec_command.bind @, filename
    )

    grunt.log.writeln "Processing tasks..."
    async.series functions, (error) ->
      if error
        throw new Error("E002: Failed to run task")
      else
        grunt.log.writeln "All done."
        done_callback()


  grunt.registerMultiTask "redirect", "Redirect", redirect_task_func
