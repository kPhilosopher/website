module.exports = (grunt) ->
  grunt.initConfig
    coffee:
      src:
        expand: true
        cwd: "src/coffeescript"
        src: ["**/*.coffee"]
        dest: "js"
        ext: ".js"
    watch:
      coffee:
        files: "**/*.coffee"
        tasks: [
          "coffee:src"
        ]
      sass:
        files: "src/sass/**/*.sass"
        tasks: [
          "sass:dist"
        ]
    sass:
      dist:
        options: 
          style: "compact"
        files: "css/main.css": "src/sass/main.sass"
        
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-sass"
  grunt.registerTask "test", [
    "jshint"
    "qunit"
  ]
