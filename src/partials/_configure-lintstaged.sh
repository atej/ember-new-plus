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