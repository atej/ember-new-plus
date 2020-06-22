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