module.exports = function( grunt ) {

	// load all tasks automagically
	require( 'load-grunt-tasks' )( grunt );

	// load timer plugin
	require( 'time-grunt' )( grunt );
	
	// all configurations
	grunt.initConfig( {
		pkg: grunt.file.readJSON( 'package.json' ),
		paths: {
			rel: 'ex_theme',
			php: {
				files: [ '<%= paths.rel %>/*.php', '<%= paths.rel %>/**/**.php', '<%= paths.rel %>/**/**/**.php' ]
			},
			sass: {
				dir: '<%= paths.rel %>/sass',
				files: '<%= paths.sass.dir %>/**/*.scss'
			},
			css: {
				dir: '<%= paths.rel %>/'
			},
			js: {
				dir: '<%= paths.rel %>/js',
				src: '<%= paths.js.dir %>/src',
				dist: '<%= paths.js.dir %>/dist',
				files: [
					'<%= paths.js.src %>/*.js',
					'<%= paths.js.src %>/**/*.js',
					'!<%= paths.js.dir %>/*.min.js',
					'!<%= paths.js.dir %>/**/*.min.js',
					'Gruntfile.js',
					'!node_modules/*.js',
					'!node_modules/*/**.js'
				]
			}
		},
		exec: {
			build: {
				cmd: function () {
					return "source theme_zip.sh <%= paths.rel %>";
				}
			}
		},
		uglify: {
			options: {
				sourceMap: true,
				preserveComments: function ( node ) {
					if ( 0 !== node.start.comments_before.length && 'comment2' === node.start.comments_before[0].type ) {
						return true;
					} else {
						return false;
					}
				}
			},
			src: {
				files: [{
					expand: true,
					cwd: '<%= paths.js.src %>',
					src: '**/*.js',
					dest: '<%= paths.js.dist %>',
					ext: '.min.js'
				}]
			}
		},
		sass: {
			options: {
				style: 'expanded'
			},
			dist: {
				files: [{
					expand: true,
					cwd: '<%= paths.sass.dir %>',
					src: ['**/*.scss'],
					dest: '<%= paths.rel %>',
					ext: '.css'
				}]
			}
		},
		jshint: {
			options: {
				curly: true,
				eqeqeq: true,
				browser: true,
				devel: true,
				undef: true,
				unused: false,
				globals: {
					'jQuery': true,
					'console': true,
					'module': true,
					'require': true,
					'wp': true
				}
			},
			scripts: '<%= paths.js.files %>',
			gruntfile: [ 'Gruntfile.js' ]
		},
		phplint: {
			options: {
				phpArgs: {
					'-lf': null
				}
			},
			all: {
				src: '<%= paths.php.files %>'
			}
		},
		watch: {
			sass: {
				files: '<%= paths.sass.files %>',
				tasks: ['sass'],
				options: {
					spawn: false
				}
			},
			js: {
				files: '<%= paths.js.files %>',
				tasks: ['jshint', 'uglify:src'],
				options: {
					spawn: false
				}
			},
			php: {
				files: '<%= paths.php.files %>',
				tasks: ['phplint'],
				options: {
					spawn: false
				}
			}
		},
		concurrent: {
			options: {
					logConcurrentOutput: true
			},
			dev: {
				tasks: [
					'watch:sass',
					'watch:js',
					'watch:php'
				]
			}
		}
	});

	// continuous testing
	grunt.registerTask( 'dev', [ 'concurrent:dev' ] );

	grunt.registerTask( 'build', [ 'phplint', 'jshint', 'uglify:src', 'sass', 'exec:build' ] );
	grunt.registerTask( 'ugly-js', [ 'uglify:src' ] );
	grunt.registerTask( 'lint', [ 'phplint', 'jshint:scripts' ] );
	grunt.registerTask( 'lint-grunt', [ 'jshint:gruntfile' ] );
};
