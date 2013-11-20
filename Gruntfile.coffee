module.exports = (grunt)->
  grunt.loadTasks "tasks"

  grunt.initConfig
    redirect:
      dist:
        files:
          "test.txt": "gcc --version"

