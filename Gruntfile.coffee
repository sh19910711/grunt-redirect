module.exports = (grunt)->
  grunt.initConfig
    # run test
    redirect:
      dist:
        files:
          "tmp/test01.txt": "gcc --version"
          "tmp/test02.txt": "gcc --version"

    # mocha
    mochaTest:
      test:
        options:
          reporter: "spec"
          colors: false
          require: [
            "coffee-script"
            "should"
          ]
        src: [
          "spec/**/*_spec.coffee"
        ]

  grunt.registerTask(
    "test"
    [
      "mochaTest:test"
    ]
  )

  # load tasks
  grunt.loadTasks "tasks"

  # load npm tasks
  pkg = grunt.file.readJSON 'package.json'
  for task of pkg.devDependencies when /^grunt-/.test task
    grunt.loadNpmTasks task
