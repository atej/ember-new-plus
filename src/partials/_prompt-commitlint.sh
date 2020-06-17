if [ $skip_git_hooks_setup != "true" ]; then
  echo -e "📩 ${YELLOW}Git hook: do you want to lint your commit messages?${NC}"
  select commitlint_choice in "Yes" "No" "Cancel"; do
    case $commitlint_choice in
      Yes) skip_commitlint_setup="false"; break;;
      No) skip_commitlint_setup="true"; break;;
      Cancel) exit;;
    esac
  done
  echo
else 
  skip_commitlint_setup="true"
fi