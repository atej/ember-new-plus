# Prompts for "Debugger for Chrome"
echo -e "🐞 ${LCYAN}Do you want to setup in-editor debugging?${NC}"
select debugger_choice in "Yes" "No" "Cancel"; do
  case $debugger_choice in
    Yes) skip_debugger_setup="false"; break;;
    No) skip_debugger_setup="true"; break;;
    Cancel) exit;;
  esac
done
echo

if [ $skip_debugger_setup != 'true' ]; then
  finished=false
  while ! $finished; do
    read -p "🔢 Enter the port where you expect to serve the app (e.g. 4200) "
    if [[ $REPLY =~ ^([1-9][0-9]{3})$ ]]; then
      serve_port=$REPLY
      finished=true
      echo
    else
      echo -e "${RED}Please choose a four digit port number${NC}"
    fi
  done

  finished=false
  while ! $finished; do
    read -p "🔢 Enter the port you want to set for remote debugging (e.g. 9357) "
    if [[ $REPLY =~ ^([1-9][0-9]{3})$ ]]; then
      remote_debugging_port=$REPLY
      finished=true
      echo
    else
      echo -e "${RED}Please choose a four digit port number${NC}"
    fi
  done
fi