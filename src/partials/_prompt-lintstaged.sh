if [ skip_git_hooks_setup != "true" ]; then
  echo -e "🧹 ${YELLOW}Git hook: do you want to lint staged files before commiting?${NC}"
  select lintstaged_choice in "Yes" "No" "Cancel"; do
    case $lintstaged_choice in
      Yes) skip_lintstaged_setup="false"; break;;
      No) skip_lintstaged_setup="true"; break;;
      Cancel) exit;;
    esac
  done
  echo
fi