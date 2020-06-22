if [ $skip_git_hooks_setup == "true" ]; then
  echo
  echo -e "⤼ ${YELLOW}Skipping git hooks setup... ${NC}"
  echo
else
  echo
  echo -e "${LCYAN}Setting up git hooks...${NC}"
  echo

  echo -e "${YELLOW}🚧 Installing dependencies...${NC}"
  echo
  $pkg_cmd -D husky@$HUSKY_VERSION

  echo -e "⚙️  ${YELLOW}Creating a husky config file...${NC}"
  > "husky.config.js" # truncates existing file (or creates empty)

  echo "'use strict';

module.exports = {
  hooks: {" >> husky.config.js

  if [ $skip_lintstaged_setup != "true" ]; then
sed -i.bak "\$a\\
\ \ \ \ 'pre-commit': 'lint-staged',
" husky.config.js
  fi

  if [ $skip_commitlint_setup != "true" ]; then
sed -i.bak "\$a\\
\ \ \ \ 'commit-msg': 'commitlint -E HUSKY_GIT_PARAMS',
" husky.config.js
  fi

  sed -i.bak '$a\
\ \ },\
};
' husky.config.js

  # sed cleanup
  rm husky.config.js.bak
fi