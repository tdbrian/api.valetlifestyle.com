module.exports = (grunt) ->
  
  # Project configuration.
  grunt.initConfig
    
    pkg: grunt.file.readJSON("package.json")

    coffee_build:
      options:
        wrap: false # wrap the result into an anonymous function
        sourceMap: true # generate source maps
      nodejs_build:
        options:
          disableModuleWrap: ['platform/nodejs_init.js', 'platform/nodejs_export.js']
        files: [
          {src: ['app/**/*.coffee'], dest: 'app/api.js'}
        ]

    notify:
      coffee:
        options:
          message: 'Coffee Compiled'
      deployed:
        options:
          message: 'Deploy Complete'
      
    watch:
      coffee:
        files: ['app/**/*.coffee']
        tasks: ['default']

  grunt.loadNpmTasks "grunt-coffee-build"
  grunt.loadNpmTasks "grunt-sftp-deploy"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-notify"
  
  # Default task(s).
  grunt.registerTask "default", ["coffee_build", "notify:coffee"]
