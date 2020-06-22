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