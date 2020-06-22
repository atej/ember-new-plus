#!/bin/bash

# ---------------
# Color Variables
# ---------------
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
LCYAN='\033[1;36m'
NC='\033[0m' # No Color

# -------------------------------------
# Prompts for configuration preferences
# -------------------------------------

# Package Manager Prompt
echo
echo -e "📦️ ${LCYAN}Which package manager are you using?${NC}"
select package_manager_choices in "yarn" "npm" "Cancel"; do
  case $package_manager_choices in
    yarn) pkg_cmd='yarn add'; pkg_man='yarn'; break;;
    npm) pkg_cmd='npm install'; pkg_man='npm'; break;;
    Cancel) exit;;
  esac
done
echo

# ESLint+Prettier Prompt
echo -e "🎨 ${LCYAN}Do you want to setup eslint+prettier?${NC}"
select eslint_prettier_choice in "Yes" "No" "Cancel"; do
  case $eslint_prettier_choice in
    Yes) skip_eslint_prettier_setup="false"; break;;
    No) skip_eslint_prettier_setup="true"; break;;
    Cancel) exit;;
  esac
done
echo

if [ $skip_eslint_prettier_setup != "true" ]; then
  # Max Line Length Prompt
  finished=false
  while ! $finished; do
    read -p "🔢 What max line length do you want to prefer? (Recommendation: 80) "
    echo
    if [[ $REPLY =~ ^[0-9]{2,3}$ ]]; then
      max_len_val=$REPLY
      finished=true
      echo
    else
      echo -e "${RED}Please choose a max length of two or three digits, e.g. 80 or 100 or 120${NC}"
    fi
  done
fi



# stylelint prompt
echo -e "👔 ${LCYAN}Do you want to setup css linting with stylelint?${NC}"
select stylelint_choice in "Yes" "No" "Cancel"; do
  case $stylelint_choice in
    Yes) skip_stylelint_setup="false"; break;;
    No) skip_stylelint_setup="true"; break;;
    Cancel) exit;;
  esac
done
echo

# ---------------------
# Perform Configuration
# ---------------------

echo
echo -e "✨ ${GREEN}Configuring your shiny development environment... ${NC}"

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

if [ $skip_stylelint_setup == "true" ]; then
  echo
  echo -e "⤼ ${YELLOW}Skipping stylelint setup... ${NC}"
  echo
else
  echo
  echo -e "${LCYAN}Setting up css linting with stylelint... ${NC}"
  echo

  echo
  echo -e "${YELLOW}🚧 Installing dependencies... ${NC}"
  echo
  $pkg_cmd -D stylelint stylelint-config-standard

  echo
  echo -e "⚙️  ${YELLOW}Creating a stylelint config file...${NC}"
  > "stylelint.config.js" # truncates existing file (or creates empty)
  echo

  echo "'use strict';

module.exports = {
  extends: ['stylelint-config-standard'],
  rules: {
  },
};" >> stylelint.config.js

  if [ $skip_tailwind_setup != "true" ]; then
    sed -i.bak "/rules/a\\
\ \ \ \ 'at-rule-no-unknown': [\\
\ \ \ \ \ \ true,\\
\ \ \ \ \ \ {\\
\ \ \ \ \ \ \ \ ignoreAtRules: [\\
\ \ \ \ \ \ \ \ \ \ 'tailwind',\\
\ \ \ \ \ \ \ \ \ \ 'apply',\\
\ \ \ \ \ \ \ \ \ \ 'variants',\\
\ \ \ \ \ \ \ \ \ \ 'responsive',\\
\ \ \ \ \ \ \ \ \ \ 'screen',\\
\ \ \ \ \ \ \ \ ],\\
\ \ \ \ \ \ },\\
\ \ \ \ ],
" stylelint.config.js

    # sed cleanup
    rm stylelint.config.js.bak
  fi

  echo
  echo -e "🏃 ${YELLOW}Adding a run script to lint css...${NC}"
  echo

  sed -i.bak '/lint:hbs/a\
\ \ \ \ "lint:css": "stylelint app/styles",
' package.json

  # sed cleanup
  rm package.json.bak

  echo
  echo -e "🤷🏻 ${YELLOW}Creating the stylelint ignore file... ${NC}"
  > .stylintignore # truncates existing file (or creates empty)
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
/package.json.ember-try' >> .stylintignore

fi

echo
echo -e "${LCYAN}Setting up VS Code workspace settings... ${NC}"
echo

# Create the vscode settings folder
if [ ! -d  .vscode ]; then
  mkdir .vscode
fi

echo
echo -e "⚙️  ${YELLOW}Creating a settings.json file...${NC}"
  > ".vscode/settings.json" # truncates existing file (or creates empty)
echo

echo '{
  "html.format.enable": true,
  "html.format.endWithNewline": true,
  "[html]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "editor.formatOnPaste": true,
    "editor.formatOnSave": true
  },

  "[handlebars]": {
    "editor.defaultFormatter": "AdamBaker.vsc-prettier-glimmer",
    "editor.formatOnPaste": true,
    "editor.formatOnSave": true
  },

  "[javascript]": {
    "editor.defaultFormatter": "dbaeumer.vscode-eslint",
    "editor.formatOnPaste": true,
    "editor.codeActionsOnSave": {
      "source.fixAll.eslint": true
    }
  },

  "[json]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "editor.formatOnPaste": true,
    "editor.formatOnSave": true
  },

  "[jsonc]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "editor.formatOnPaste": true,
    "editor.formatOnSave": true
  }
}' >> .vscode/settings.json

if [ $skip_stylelint_setup != "true" ]; then
  sed -i.bak '/javascript/i\
\ \ "css.validate": false,\
\ \ "[css]": {\
\ \ \ \ "editor.defaultFormatter": "stylelint.vscode-stylelint",\
\ \ \ \ "editor.formatOnPaste": true,\
\ \ \ \ "editor.codeActionsOnSave": {\
\ \ \ \ \ \ "source.fixAll.stylelint": true\
\ \ \ \ }\
\ \ },\
\
' .vscode/settings.json

  # sed cleanup
  rm .vscode/settings.json.bak
fi



# Create the vscode settings folder
if [ ! -d  .vscode ]; then
  mkdir .vscode
fi

echo
echo -e "⚙️  ${YELLOW}Creating an extensions.json file (for recommended VS Code extensions)...${NC}"
> ".vscode/extensions.json" # truncates existing file (or creates empty)
echo

echo '{
  "recommendations": [
    // ember
    "candidmetrics.ember-module-snippets",
    "emberjs.emberjs",
    "emberjs.vscode-ember",
    "felixrieseberg.vsc-ember-cli",
    "josa.ember-related-files",
    "phanitejakomaravolu.EmberES6Snippets",

    // syntax : glimmer
    "dhedgecock.ember-syntax",

    // formatting: glimmer
    "AdamBaker.vsc-prettier-glimmer",
' >> .vscode/extensions.json

if [ $skip_tailwind_setup != "true" ]; then
  sed -i.bak '$a\
\ \ \ \ // tailwindcss\
\ \ \ \ "bradlc.vscode-tailwindcss",\
\ \ \ \ "heybourn.headwind",\
\
' .vscode/extensions.json
fi


if [ $skip_debugger_setup != "true" ]; then
  sed -i.bak '$a\
\ \ \ \ // debug: js\
\ \ \ \ "msjsdiag.debugger-for-chrome",\
\
' .vscode/extensions.json
fi

if [ $skip_stylelint_setup != "true" ]; then
  sed -i.bak '$a\
\ \ \ \ // lint: css\
\ \ \ \ "stylelint.vscode-stylelint",\
\
' .vscode/extensions.json
fi

sed -i.bak '$a\
\ \ \ \ // lint and format: js\
\ \ \ \ "dbaeumer.vscode-eslint",\
\ \ \ \ "esbenp.prettier-vscode",\
\
\ \ \ \ // git\
\ \ \ \ "eamodio.gitlens",\
\
\ \ \ \ // comments\
\ \ \ \ "aaron-bond.better-comments",\
\
\ \ \ \ // visual enhancements\
\ \ \ \ "CoenraadS.bracket-pair-colorizer-2",\
\ \ \ \ "oderwat.indent-rainbow",\
\
\ \ \ \ // productivity\
\ \ \ \ "BriteSnow.vscode-toggle-quotes",\
\ \ \ \ "nanlei.save-all"\
\ \ ]\
}
' .vscode/extensions.json

# sed cleanup
rm .vscode/extensions.json.bak

echo
echo -e "⚙️  ${YELLOW}Creating a jsconfig file... ${NC}"
> "jsconfig.json"

echo '{
  "compilerOptions": { "target": "es6", "experimentalDecorators": true },
  "exclude": [
    "node_modules",
    "bower_components",
    "tmp",
    "vendor",
    ".git",
    "dist"
  ]
}' >> jsconfig.json
echo

echo
echo -e "✅ ${GREEN}Finished setting up!${NC}"
echo
echo -e "🌐 Start server with ${LCYAN}${pkg_man} run start${NC}"
if [ $skip_debugger_setup != 'true' ]; then
  echo -e "🐞 Start a chrome debugger instance with ${LCYAN}${pkg_man} run debug${NC}"
fi
echo
