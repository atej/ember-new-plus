#!/bin/bash

# ---------------
# Color Variables
# ---------------
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
LCYAN='\033[1;36m'
NC='\033[0m' # No Color

# ----------------
# Package Versions
# ----------------

HUSKY_VERSION=^3.1.0
ESLINT_CONFIG_AIRBNB_BASE_VERSION=14.1.0

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

# Prompts for "Debugger for Chrome"
echo -e "🐞 ${LCYAN}Do you want to setup in-editor debugging?${NC}"
select debugger_choice in "Yes" "No" "Cancel"; do
  case $debugger_choice in
    Yes) skip_debugger_setup="false"; break;;
    No) skip_debugger_setup="true"; break;;
    Cancel) exit;;
  esac
done
echo

if [ $skip_debugger_setup != 'true' ]; then
  finished=false
  while ! $finished; do
    read -p "🔢 Enter the port where you expect to serve the app (e.g. 4200) "
    if [[ $REPLY =~ ^([1-9][0-9]{3})$ ]]; then
      serve_port=$REPLY
      finished=true
      echo
    else
      echo -e "${RED}Please choose a four digit port number${NC}"
    fi
  done

  finished=false
  while ! $finished; do
    read -p "🔢 Enter the port you want to set for remote debugging (e.g. 9357) "
    if [[ $REPLY =~ ^([1-9][0-9]{3})$ ]]; then
      remote_debugging_port=$REPLY
      finished=true
      echo
    else
      echo -e "${RED}Please choose a four digit port number${NC}"
    fi
  done
fi

# Tailwind Prompt
echo -e "🌊 ${LCYAN}Do you want to setup tailwind css?${NC}"
select tailwind_choice in "Yes" "No" "Cancel"; do
  case $tailwind_choice in
    Yes) skip_tailwind_setup="false"; break;;
    No) skip_tailwind_setup="true"; break;;
    Cancel) exit;;
  esac
done
echo

# git hooks prompt
echo -e "🐶 ${LCYAN}Do you want to setup git hooks with husky?${NC}"
select git_hooks_choice in "Yes" "No" "Cancel"; do
  case $git_hooks_choice in
    Yes) skip_git_hooks_setup="false"; break;;
    No) skip_git_hooks_setup="true"; break;;
    Cancel) exit;;
  esac
done
echo

if [ $skip_git_hooks_setup != "true" ]; then
  echo -e "🧹 ${YELLOW}Git hook: do you want to lint staged files before commiting?${NC}"
  select lintstaged_choice in "Yes" "No" "Cancel"; do
    case $lintstaged_choice in
      Yes) skip_lintstaged_setup="false"; break;;
      No) skip_lintstaged_setup="true"; break;;
      Cancel) exit;;
    esac
  done
  echo
else
  skip_lintstaged_setup="true"
fi

if [ $skip_git_hooks_setup != "true" ]; then
  echo -e "📩 ${YELLOW}Git hook: do you want to lint your commit messages?${NC}"
  select commitlint_choice in "Yes" "No" "Cancel"; do
    case $commitlint_choice in
      Yes) skip_commitlint_setup="false"; break;;
      No) skip_commitlint_setup="true"; break;;
      Cancel) exit;;
    esac
  done
  echo
else 
  skip_commitlint_setup="true"
fi

# ---------------------
# Perform Configuration
# ---------------------

echo
echo -e "✨ ${GREEN}Configuring your shiny development environment... ${NC}"

if [ "$skip_eslint_prettier_setup" == "true" ]; then
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

if [ "$skip_stylelint_setup" == "true" ]; then
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

if [ "$skip_tailwind_setup" == "true" ]; then
  echo
  echo -e "⤼ ${YELLOW}Skipping tailwind setup... ${NC}"
  echo
else
  echo
  echo -e "${LCYAN}Setting up tailwind css... ${NC}"
  echo

  echo
  echo -e "${YELLOW}🚧 Installing dependencies... ${NC}"
  echo

  $pkg_cmd -D tailwindcss postcss-import postcss-preset-env @fullhuman/postcss-purgecss
  ember install ember-cli-postcss

  echo
  echo -e "⚙️  ${YELLOW}Creating a postcss config file...${NC}"
  > "postcss.config.js" # truncates existing file (or creates empty)
  echo

  echo "'use strict';

const { join } = require('path');
const EmberApp = require('ember-cli/lib/broccoli/ember-app');
const postcssImport = require('postcss-import');
const tailwindCSS = require('tailwindcss')('./app/tailwind/config.js');
const postcssPresetEnv = require('postcss-preset-env')({ stage: 1 });

const purgecss = require('@fullhuman/postcss-purgecss')({
  content: [
    join(__dirname, 'app', 'index.html'),
    join(__dirname, 'app', 'templates', '**', '*.hbs'),
    join(__dirname, 'app', 'components', '**', '*.hbs'),
  ],

  defaultExtractor: (content) => {
    const broadMatches = content.match(/[^<>\"'\`\\s]*[^<>\"'\`\\s:]/g) || [];
    const innerMatches = content.match(/[^<>\"'\`\\s.()]*[^<>\"'\`\\s.():]/g) || [];

    return broadMatches.concat(innerMatches);
  },
});

module.exports = {
  plugins: [
    postcssImport,
    tailwindCSS,
    postcssPresetEnv,
    ...(EmberApp.env() === 'production' ? [purgecss] : []),
  ],
};" >> postcss.config.js

  echo
  echo -e "⨠ ${YELLOW}Importing postcss config into the the ember build pipeline...${NC}"
  echo

  sed -i.bak "/EmberApp =/a\\
const postcssConfig = require('./postcss.config.js');
" ember-cli-build.js

  sed -i.bak '/new EmberApp/a\
\ \ \ \ postcssOptions: {\
\ \ \ \ \ \ compile: postcssConfig,\
\ \ \ \ },
' ember-cli-build.js

  # sed cleanup
  rm ember-cli-build.js.bak

  if [ ! -d  ./app/tailwind ]; then
    mkdir ./app/tailwind
  fi

  echo
  echo -e "⚙️  ${YELLOW}Creating an empty tailwind config file...${NC}"
  > "app/tailwind/config.js" # truncates existing file (or creates empty)
  echo

  echo "'use strict';

module.exports = {
  theme: {
    extend: {},
  },
  variants: {},
  plugins: [],
};" >> app/tailwind/config.js

  # Temporary workaround to make Tailwind Intellisense work
  echo
  echo -e "⨠ ${YELLOW}Importing tailwind config to a file located in app root (for Tailwind Intellisense to work)...${NC}"
  > "tailwind.config.js" # truncates existing file (or creates empty)
  echo

  echo "'use strict';

const tailwindConfig = require('./app/tailwind/config');

module.exports = tailwindConfig;" >> tailwind.config.js

  echo
  echo -e "⚙️  ${YELLOW}Creating a tailwind source css file...${NC}"
  > "app/styles/app.css" # truncates existing file (or creates empty)
  echo

  echo '/* purgecss start ignore */

@import "tailwindcss/base";
@import "./base";
@import "tailwindcss/components";
@import "./components";

/* purgecss end ignore */

@import "tailwindcss/utilities";

/* purgecss start ignore */

@import "./utilities";

/* purgecss end ignore */' >> app/styles/app.css

  echo
  echo -e "⚙️  ${YELLOW}Creating custom css files...${NC}"
  echo

  echo "/* custom base styles */" >> app/styles/base.css
  echo "/* custom component styles */" >> app/styles/components.css
  echo "/* custom utility styles */" >> app/styles/utilities.css
fi

if [ "$skip_lintstaged_setup" == "true" ]; then
  echo
  echo -e "⤼ ${YELLOW}Skipping lint staged setup... ${NC}"
  echo
else
  echo
  echo -e "${LCYAN}Setting up pre commit hook to lint staged files... ${NC}"
  echo
  
  echo
  echo -e "${YELLOW}🚧 Installing dependencies...${NC}"
  echo
  $pkg_cmd -D lint-staged

  echo
  echo -e "⚙️  ${YELLOW}Creating a lint-staged config file...${NC}"
  > "lint-staged.config.js" # truncates existing file (or creates empty)
  echo

  echo "'use strict';

module.exports = {
  '*.js': 'eslint',
  '*.hbs': 'ember-template-lint'," >> lint-staged.config.js

  if [ $skip_stylelint_setup != "true" ]; then
  sed -i.bak "\$a\\
\ \ '*.css': 'stylelint',
" lint-staged.config.js
  fi

  sed -i.bak '$a\
};
' lint-staged.config.js

  # sed cleanup
  rm lint-staged.config.js.bak
fi

if [ "$skip_commitlint_setup" == "true" ]; then
  echo
  echo -e "⤼ ${YELLOW}Skipping commitlint setup... ${NC}"
  echo
else
  echo
  echo -e "${LCYAN}Setting up linting of commit messages... ${NC}"
  echo

  echo
  echo -e "${YELLOW}🚧 Installing dependencies...${NC}"
  echo "For more information see here https://www.conventionalcommits.org/"
  echo
  $pkg_cmd -D @commitlint/cli @commitlint/config-conventional

  echo
  echo -e "⚙️  ${YELLOW}Creating a commitlint config file...${NC}"
  > "commitlint.config.js" # truncates existing file (or creates empty)
  echo

  echo "'use strict';

module.exports = {
  extends: ['@commitlint/config-conventional'],
};" >> commitlint.config.js
fi

if [ $skip_debugger_setup = 'true' ]; then
  echo
  echo -e "⤼ ${YELLOW}Skipping in-editor debugging setup...${NC}"
  echo
else
  echo
  echo -e "${LCYAN}Setting up in-editor debugging... ${NC}"
  echo
  echo
  echo -e "${YELLOW}Getting the app name...${NC}"
  echo
  searchstring='modulePrefix:'
  line=`awk '/'${searchstring}'/' ./config/environment.js`
  temp_a=${line#*$searchstring}

  if [[ $line == *"'"* ]]; then
    singlequote=true
  fi

  if [ $singlequote = 'true' ]; then
    temp_b=${temp_a#*"'"}
    appname=${temp_b%"'"*}
  else
    temp_b=${temp_a#*'"'}
    appname=${temp_b%'"'*}
  fi

  echo
  echo -e "The app name found: <${LCYAN}${appname}${NC}>"
  echo

  if [ ! -d  .vscode ]; then
    mkdir .vscode
  fi

  echo
  echo -e "⚙️  ${YELLOW}Creating a launch.json file...${NC}"
  > ".vscode/launch.json" # truncates existing file (or creates empty)
  echo

  echo '{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "chrome",
      "request": "attach",
      "name": "Attach to Chrome",
      "port": '${remote_debugging_port}',
      "url": "http://localhost:'${serve_port}'*",
      "webRoot": "${workspaceFolder}",
      "sourceMapPathOverrides": {
        "'${appname}'/*": "${workspaceFolder}/app/*"
      }
    }
  ]
}' >> .vscode/launch.json

  echo
  echo -e "🏃 ${YELLOW}Adding a run script to start a chrome debugging instance...${NC}"
  echo

  sed -i.bak "/\"start\": \"ember serve\"/a\\
\\ \\ \\ \\ \"debug\": \"/Applications/Google\\\\\\\\ Chrome.app/Contents/MacOS/Google\\\\\\\\ Chrome --remote-debugging-port=9357 --no-first-run --no-default-browser-check --incognito --user-data-dir=\$(mktemp -d -t \'chrome-remote_data_dir\')\",
" package.json

  # sed cleanup
  rm package.json.bak
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
