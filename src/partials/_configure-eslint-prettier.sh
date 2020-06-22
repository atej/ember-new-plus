if [ $skip_eslint_prettier_setup == "true" ]; then
  echo
  echo -e "⤼ ${YELLOW}Skipping eslint+prettier setup... ${NC}"
  echo
else
  # Install airbnb config
  echo
  echo -e "${LCYAN}Setting up eslint and prettier... ${NC}"
  echo
  echo -e "${YELLOW}🚧 Installing airbnb config... ${NC}"
  echo
  npx install-peerdeps -D eslint-config-airbnb-base@$ESLINT_CONFIG_AIRBNB_BASE_VERSION
  $pkg_cmd -D eslint-import-resolver-ember

  # Install prettier
  echo
  echo -e "${YELLOW}🚧 Installing prettier... ${NC}"
  echo
  $pkg_cmd -D prettier

  # Integrate prettier and eslint
  echo
  echo -e "${YELLOW}🚧 Installing stuff to make ESlint and Prettier play nice with each other... ${NC}"
  echo "See https://github.com/prettier/eslint-config-prettier for more details."
  echo
  $pkg_cmd -D eslint-plugin-prettier eslint-config-prettier

  echo
  echo -e "⚙️  ${YELLOW}Creating an eslint config file...${NC}"
  > ".eslintrc.js" # truncates existing file (or creates empty)
  echo

  echo "'use strict';

module.exports = {
  root: true,
  parser: 'babel-eslint',
  parserOptions: {
    ecmaVersion: 2018,
    sourceType: 'module',
    ecmaFeatures: {
      legacyDecorators: true,
    },
  },
  plugins: ['ember', 'prettier'],
  extends: [
    'airbnb-base',
    'eslint:recommended',
    'plugin:ember/recommended',
    'prettier',
  ],
  env: {
    browser: true,
  },
  rules: {
    'ember/no-jquery': 'error',
    'prettier/prettier': 'error',
    'import/no-extraneous-dependencies': ['error', { devDependencies: true }],
    'import/no-unresolved': [
      'error',
      { ignore: ['^@ember', 'htmlbars-inline-precompile'] },
    ],
  },
  settings: {
    'import/resolver': 'eslint-import-resolver-ember',
  },
  overrides: [
    // node files
    {
      files: [
        '.eslintrc.js',
        '.prettierrc.js',
        'stylelint.config.js',
        'commitlint.config.js',
        'postcss.config.js',
        'tailwind.config.js',
        'app/tailwind/config.js',
        'husky.config.js',
        'lint-staged.config.js',
        '.template-lintrc.js',
        'ember-cli-build.js',
        'testem.js',
        'blueprints/*/index.js',
        'config/**/*.js',
        'lib/*/index.js',
        'server/**/*.js',
      ],
      parserOptions: {
        sourceType: 'script',
      },
      env: {
        browser: false,
        node: true,
      },
      plugins: ['node'],
      rules: {
        // eslint-disable-next-line global-require
        ...require('eslint-plugin-node').configs.recommended.rules,
        // add your custom rules and overrides for node files here
        strict: ['error', 'global'],

        // this can be removed once the following is fixed
        // https://github.com/mysticatea/eslint-plugin-node/issues/77
        'node/no-unpublished-require': 'off',
      },
    },
  ],
};" >> .eslintrc.js

  echo
  echo -e "⚙️  ${YELLOW}Creating an eslint config file for tests...${NC}"
  > "./tests/.eslintrc.js" # truncates existing file (or creates empty)
  echo

  echo "'use strict';

module.exports = {
  root: true,
  parser: 'babel-eslint',
  parserOptions: {
    ecmaVersion: 2018,
    sourceType: 'module',
    ecmaFeatures: {
      legacyDecorators: true,
    },
  },
  plugins: ['ember', 'prettier'],
  extends: ['eslint:recommended', 'plugin:ember/recommended', 'prettier'],
  env: {
    browser: true,
  },
  rules: {
    'ember/no-jquery': 'error',
    'prettier/prettier': 'error',
  },
  overrides: [
    // node files
    {
      files: ['.eslintrc.js'],
      parserOptions: {
        sourceType: 'script',
      },
      env: {
        browser: false,
        node: true,
      },
      plugins: ['node'],
      rules: {
        // eslint-disable-next-line global-require
        ...require('eslint-plugin-node').configs.recommended.rules,
        // add your custom rules and overrides for node files here

        // this can be removed once the following is fixed
        // https://github.com/mysticatea/eslint-plugin-node/issues/77
        'node/no-unpublished-require': 'off',
      },
    },
  ],
};" >> ./tests/.eslintrc.js

# Configure prettier
  echo
  echo -e "⚙️  ${YELLOW}Creating a prettier config file... ${NC}"
  > .prettierrc.js # truncates existing file (or creates empty)
  echo

  echo "'use strict';

module.exports = {
  printWidth: ${max_len_val},
  singleQuote: true,
  overrides: [
    {
      files: '*.hbs',
      options: {
        singleQuote: false,
      },
    },
  ],
};" >> .prettierrc.js

  echo
  echo -e "🤷🏻 ${YELLOW}Creating the prettier ignore file... ${NC}"
  > .prettierignore # truncates existing file (or creates empty)
  echo

  echo '# unconventional js
/blueprints/*/files/
/vendor/

# compiled output
/dist/
/tmp/

# dependencies
/bower_components/
/node_modules/

# misc
/coverage/
!.*

# ember-try
/.node_modules.ember-try/
/bower.json.ember-try
/package.json.ember-try' >> .prettierignore

fi