# stylelint prompt
echo -e "👔 ${LCYAN}Do you want to setup css linting with stylelint?${NC}"
select stylelint_choice in "Yes" "No" "Cancel"; do
  case $stylelint_choice in
    Yes) skip_stylelint_setup="false"; break;;
    No) skip_stylelint_setup="true"; break;;
    Cancel) exit;;
  esac
done
echo