module.exports = (grunt) ->
  grunt.initConfig
    coffee:
      src:
        expand: true
        cwd: 'src/coffeescript'
        src: ['**/*.coffee']
        dest: 'js'
        ext: '.js'
    watch:
      files: '**/*.coffee'
      tasks: [
        "coffee:src"
      ]
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.registerTask "test", [
    "jshint"
    "qunit"
  ]
