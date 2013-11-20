# grunt-redirect

[Grunt](https://github.com/gruntjs/grunt) task to save command output to file.

[![Build Status](https://travis-ci.org/sh19910711/grunt-redirect.png?branch=master)](https://travis-ci.org/sh19910711/grunt-redirect)
[![Dependency Status](https://gemnasium.com/sh19910711/grunt-redirect.png)](https://gemnasium.com/sh19910711/grunt-redirect)


## Getting Started

### Installation

    $ npm install grunt-redirect

### Requirements

* `grunt --version` >= 0.4


## Options

### options.stdout
Type: `Boolean`
Default value: `true`

Set `options.stdout` to `true` to save stdout.

### options.stderr
Type: `Boolean`
Default value: `false`

Set `options.stderr` to `true` to save stderr.

### options.overwrite
Type: `Boolean`
Default value: `true`

Set `options.overwrite` to `true` to overwrite output files.


## Configuration Examples

`redirect` is a multitask, so you can use it similary to `dist`, `build` or etc...

```javascript
grunt.initConfig({
    ...
    redirect: {
      dist: {
        options: {
          stdout: true,
          stderr: false,
          overwrite: true
        },
        files: {
          "path/to/file01": "command01 arg1 arg2 ...",
          "path/to/file02": "command02 arg1 arg2 ...",
          ...
        }
      }
    }
    ...
});
```

### Usage Example to update JSON files

For example, bump version when you build your app.

```javascript
grunt.initConfig({
    ...
    redirect: {
      build: {
        files: {
          "path/to/package.json": "command package.template data.json",
          "path/to/bower.json": "command bower.template data.json",
          "path/to/manifest.json": "command manifest.template data.json",
          ...
        }
      }
    }
    ...
});
```


## License
MIT License (c) [Hiroyuki Sano](https://github.com/sh19910711)


