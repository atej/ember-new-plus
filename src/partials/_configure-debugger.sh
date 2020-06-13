if [ $skip_debugger_setup = 'true' ]; then
  echo
  echo -e "⤼ ${YELLOW}Skipping in-editor debugging setup...${NC}"
  echo
else
  echo
  echo -e "${LCYAN}Setting up in-editor debugging... ${NC}"
  echo
  echo
  echo -e "${YELLOW}Getting the app name...${NC}"
  echo
  searchstring='modulePrefix:'
  line=`awk '/'${searchstring}'/' ./config/environment.js`
  temp_a=${line#*$searchstring}

  if [[ $line == *"'"* ]]; then
    singlequote=true
  fi

  if [ $singlequote = 'true' ]; then
    temp_b=${temp_a#*"'"}
    appname=${temp_b%"'"*}
  else
    temp_b=${temp_a#*'"'}
    appname=${temp_b%'"'*}
  fi

  echo
  echo -e "The app name found: <${LCYAN}${appname}${NC}>"
  echo

  if [ ! -d  .vscode ]; then
    mkdir .vscode
  fi

  echo
  echo -e "⚙️  ${YELLOW}Creating a launch.json file...${NC}"
  > ".vscode/launch.json" # truncates existing file (or creates empty)
  echo

  echo '{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "chrome",
      "request": "attach",
      "name": "Attach to Chrome",
      "port": '${remote_debugging_port}',
      "url": "http://localhost:'${serve_port}'*",
      "webRoot": "${workspaceFolder}",
      "sourceMapPathOverrides": {
        "'${appname}'/*": "${workspaceFolder}/app/*"
      }
    }
  ]
}' >> .vscode/launch.json

  echo
  echo -e "🏃 ${YELLOW}Adding a run script to start a chrome debugging instance...${NC}"
  echo

  sed -i.bak "/\"start\": \"ember serve\"/a\\
\\ \\ \\ \\ \"debug\": \"/Applications/Google\\\\\\\\ Chrome.app/Contents/MacOS/Google\\\\\\\\ Chrome --remote-debugging-port=9357 --no-first-run --no-default-browser-check --incognito --user-data-dir=\$(mktemp -d -t \'chrome-remote_data_dir\')\",
" package.json

  # sed cleanup
  rm package.json.bak
fi