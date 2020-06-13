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