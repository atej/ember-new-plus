if [ $skip_commitlint_setup == "true" ]; then
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