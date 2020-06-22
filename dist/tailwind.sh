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

# ---------------------
# Perform Configuration
# ---------------------

echo
echo -e "✨ ${GREEN}Configuring your shiny development environment... ${NC}"

if [ $skip_tailwind_setup == "true" ]; then
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

echo
echo -e "✅ ${GREEN}Finished setting up!${NC}"
echo
echo -e "🌐 Start server with ${LCYAN}${pkg_man} run start${NC}"
if [ $skip_debugger_setup != 'true' ]; then
  echo -e "🐞 Start a chrome debugger instance with ${LCYAN}${pkg_man} run debug${NC}"
fi
echo
