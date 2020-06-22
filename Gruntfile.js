module.exports = function(grunt) {
  const options = {
    separator: '\n\n',
    footer: '\n'
  };

	grunt.initConfig({
		concat: {
      emberNewPlus: {
        options,
        src: [
          'src/partials/_define-shell.sh',
          'src/vars/_colors.sh',
          'src/vars/_package-versions.sh',
          'src/partials/_comment-prompts.sh',
          'src/partials/_prompt-package_manager.sh',
          'src/partials/_prompt-eslint-prettier.sh',
          'src/partials/_prompt-stylelint.sh',
          'src/partials/_prompt-debugger.sh',
          'src/partials/_prompt-tailwind.sh',
          'src/partials/_prompt-git_hooks.sh',
          'src/partials/_prompt-lintstaged.sh',
          'src/partials/_prompt-commitlint.sh',
          'src/partials/_comment-configure.sh',
          'src/partials/_start-configure.sh',
          'src/partials/_configure-eslint-prettier.sh',
          'src/partials/_configure-stylelint.sh',
          'src/partials/_configure-tailwind.sh',
          'src/partials/_configure-husky.sh',
          'src/partials/_configure-lintstaged.sh',
          'src/partials/_configure-commitlint.sh',
          'src/partials/_configure-debugger.sh',
          'src/partials/_configure-workspace.sh',
          'src/partials/_configure-extensions.sh',
          'src/partials/_configure-jsconfig.sh',
          'src/partials/_end-configure.sh',
        ],
        dest: 'dist/ember-new-plus.sh'
      },
      lintAndFormat: {
        options,
        src: [
          'src/partials/_define-shell.sh',
          'src/vars/_colors.sh',
          'src/partials/_comment-prompts.sh',
          'src/partials/_prompt-package_manager.sh',
          'src/partials/_prompt-eslint-prettier.sh',
          'src/partials/_prompt-stylelint.sh',
          'src/partials/_comment-configure.sh',
          'src/partials/_start-configure.sh',
          'src/partials/_configure-eslint-prettier.sh',
          'src/partials/_configure-stylelint.sh',
          'src/partials/_configure-workspace.sh',
          'src/partials/_configure-extensions.sh',
          'src/partials/_configure-jsconfig.sh',
          'src/partials/_end-configure.sh',
        ],
        dest: 'dist/eslint-prettier-vscode.sh'
      },
      tailwind: {
        options,
        src: [
          'src/partials/_define-shell.sh',
          'src/vars/_colors.sh',
          'src/partials/_comment-prompts.sh',
          'src/partials/_prompt-package_manager.sh',
          'src/partials/_prompt-tailwind.sh',
          'src/partials/_comment-configure.sh',
          'src/partials/_start-configure.sh',
          'src/partials/_configure-tailwind.sh',
          'src/partials/_end-configure.sh',
        ],
        dest: 'dist/tailwind.sh'
      },
		}

	});

	grunt.loadNpmTasks('grunt-contrib-concat');

	grunt.registerTask('default', ['concat']);
};