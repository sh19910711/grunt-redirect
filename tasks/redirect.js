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
  grunt.registerMultiTask(
      'redirect',
      'Redirect',
      function() {
        var callback = this.async();
        var options = this.data;
        var commands = options.files;
        var files = _(options.files).keys();
        var functions = _(files).map(
          function(filename) {
            return function() {
              console.log("filename: ", filename);
              grunt.util.spawn(
                {
                  cmd: commands[filename]
                },
                function(error, result, code) {
                  console.log(arguments);
                }
              );
            };
          }
        );
        async.series(
            functions,
            function() {
              console.log("finish");
            }
        );
      }
    );
};

