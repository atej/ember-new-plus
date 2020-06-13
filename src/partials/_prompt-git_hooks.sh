# git hooks prompt
echo -e "🐕️ ${LCYAN}Do you want to setup git hooks with husky?${NC}"
select git_hooks_choice in "Yes" "No" "Cancel"; do
  case $git_hooks_choice in
    Yes) skip_git_hooks_setup="false"; break;;
    No) skip_git_hooks_setup="true"; break;;
    Cancel) exit;;
  esac
done
echo