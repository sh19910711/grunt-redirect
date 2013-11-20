module.exports = (grunt)->
  grunt.initConfig
    # run test
    redirect:
      dist:
        files:
          "../tmp/test01.txt": "node --version"
          "../tmp/test02.txt": "npm --version"

  # load tasks
  grunt.loadTasks "../../tasks"

