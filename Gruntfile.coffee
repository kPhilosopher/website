module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
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
          "mochacli"
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
    mochacli:
      options:
        compilers: ["coffee:coffee-script/register"]
        ui: "bdd"
        reporter: "spec"
      all: "test/**/*.coffee"
        
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-sass"
  grunt.loadNpmTasks "grunt-mocha-cli"
  grunt.registerTask "test", [
    "jshint"
    "qunit"
  ]
