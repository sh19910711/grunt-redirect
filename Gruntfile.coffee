module.exports = (grunt)->
  grunt.loadTasks "tasks"

  # run test
  grunt.initConfig
    redirect:
      dist:
        files:
          "tmp/test.txt": "gcc --version"

