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

