# Checks for existing prettierrc files
if [ -f ".prettierrc.js" -o -f "prettier.config.js" -o -f ".prettierrc.yaml" -o -f ".prettierrc.yml" -o -f ".prettierrc.json" -o -f ".prettierrc.toml" -o -f ".prettierrc" ]; then
  echo -e "${RED}Existing Prettier config file(s) found${NC}"
  ls -a | grep "prettier*" | xargs -n 1 basename
  echo
  echo -e "${RED}CAUTION:${NC} The configuration file will be resolved starting from the location of the file being formatted, and searching up the file tree until a config file is (or isn't) found. https://prettier.io/docs/en/configuration.html"
  echo
  read -p "❗️ Write .prettierrc.js (Y/n)? "
  echo
  if [[ $REPLY =~ ^[Nn]$ ]]; then
    echo -e "⤼ ${YELLOW}Skipping prettier config${NC}"
    echo
    skip_prettier_setup="true"
  fi
  echo
fi