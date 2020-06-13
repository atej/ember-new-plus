# Package Manager Prompt
echo
echo -e "📦️ ${LCYAN}Which package manager are you using?${NC}"
select package_manager_choices in "yarn" "npm" "Cancel"; do
  case $package_manager_choices in
    yarn) pkg_cmd='yarn add'; pkg_man='yarn'; break;;
    npm) pkg_cmd='npm install'; pkg_man='npm'; break;;
    Cancel) exit;;
  esac
done
echo