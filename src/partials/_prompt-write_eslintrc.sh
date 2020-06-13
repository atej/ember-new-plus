# Checks for existing eslintrc files
if [ -f ".eslintrc.js" -o -f ".eslintrc.yaml" -o -f ".eslintrc.yml" -o -f ".eslintrc.json" -o -f ".eslintrc" ]; then
  echo -e "${RED}Existing ESLint config file(s) found:${NC}"
  ls -a .eslint* | xargs -n 1 basename
  echo
  echo -e "${RED}CAUTION:${NC} there is loading priority when more than one config file is present: https://eslint.org/docs/user-guide/configuring#configuration-file-formats"
  echo
  read -p "❗️ Write .eslintrc.js (Y/n)? "
  echo
  if [[ $REPLY =~ ^[Nn]$ ]]; then
    echo -e "⤼ ${YELLOW}Skipping ESLint config${NC}"
    echo
    skip_eslint_setup="true"
  fi
fi