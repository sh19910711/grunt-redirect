module.exports = (grunt)->
  grunt.loadTasks "tasks"

  # run test
  grunt.initConfig
    redirect:
      dist:
        files:
          "tmp/test01.txt": "gcc --version"
          "tmp/test02.txt": "gcc --version"

