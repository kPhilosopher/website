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
      test:
        expand: true
        cwd: "test/coffeescript"
        src: ["**/*.coffee"]
        dest: "test/javascript"
        ext: ".js"
    watch:
      coffee:
        files: "**/*.coffee"
        tasks: [
          "coffee:src"
          "coffee:test"
        ]
      specs:
        files: "**/*.js"
        tasks: [
          "shell:compileSpeclist"
          "shell:phantomjs"
        ]
      sass:
        files: "src/sass/**/*.sass"
        tasks: [
          "sass:dist"
        ]
    shell:
      phantomjs:
        options:
          stdout: true
        command: 'phantomjs test/phantomjs-runner.coffee test/index.html'
      compileSpeclist:
        command: 'test/compileSpeclist.sh'
    sass:
      dist:
        options: 
          style: "compact"
        files: "css/main.css": "src/sass/main.sass"
        
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-sass"
  grunt.loadNpmTasks "grunt-shell"

  grunt.registerTask "default", ["watch"]
  grunt.registerTask "test", [
    "jshint"
    "qunit"
  ]
