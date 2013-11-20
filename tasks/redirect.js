/*
 * grunt-redirect
 * https://github.com/sh19910711/grunt-redirect
 *
 * Copyright (c) 2013 Hiroyuki Sano
 * Licensed under the MIT License.
 */
'use strict';

module.exports = function(grunt) {
  var _ = require("underscore");
  var async = require("async");
  var fs = require("fs");

  // redirect options
  var flags = {
    stdout: true,
    stderr: false
  };

  // get filenames from options
  var get_files = function get_files(options) {
    if ( typeof options === "object" ) {
      return _(options).keys();
    }
    throw new Error("E001");
  };

  // get arguments from command text
  var get_args = function get_args(text) {
    var args_text = text.match(/\s(.*)/)[1];
    var args = args_text.split(" ");
    return args;
  };

  // get commands from options
  var get_commands = function get_commands(options) {
    // split into command and args
    var keys = _(options).keys();
    var commands = _(keys).reduce(
        function(commands, key) {
          var obj = {};
          var command_text = options[key];
          if ( /\s/.test(command_text) ) {
            var command = command_text.match(/(.*)\s/)[1];
            var args = get_args(command_text);
            obj[key] = {
              command: command,
              args: args
            };
          } else {
            obj[key] = {
              command: command_text,
              args: []
            };
          }
          _(commands).extend(obj);
          return commands;
        },
        {}
    );
    return commands;
  };

  var to_boolean = function to_boolean(x) {
    return ! ! x;
  };

  // main task
  var redirect_task_func = function redirect_task_func() {
    var done_callback = this.async();
    var options = this.data;
    var commands = get_commands(options.files);
    var files = get_files(options.files);
  
    // execute command
    var exec_command = function exec_command(filename, callback) {
      var command = commands[filename];
      grunt.util.spawn(
          {
            cmd: command.command,
            args: command.args
          },
          function(error, result, code) {
            var res = to_boolean(error);
            if ( ! res ) {
              grunt.log.writeln(command.command + " > " + filename + ": OK");
            } else {
              grunt.log.writeln(command.command + " > " + filename + ": NG");
            }
            callback(res);
          }
      );
    };

    //
    // run command each file
    // 
    var functions = _(files).map(
      function(filename) {
        return exec_command.bind(this, filename);
      }
    );

    grunt.log.writeln("Processing tasks...");
    async.series(
        functions,
        function(error) {
          if ( error ) {
            throw new Error("E002");
          } else {
            grunt.log.writeln("All done.");
            done_callback();
          }
        }
    );
  };

  grunt.registerMultiTask('redirect', 'Redirect', redirect_task_func);
};

