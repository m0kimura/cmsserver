module.exports = function(grunt) {
  grunt.initConfig({
    babel: {
      dist: {
        files: [{
          "expand": true,
          "cwd": "/home/docker/webes-project/html/es/",
          "src": ["*.js"],
          "dest": "/home/docker/webes-project/html/js/",
          "ext": ".js"
        }]
      }
    }
  });
  grunt.loadNpmTasks('grunt-babel');
  grunt.registerTask('default', ['babel']);
};
