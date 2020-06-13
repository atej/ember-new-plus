echo
echo -e "✅ ${GREEN}Finished setting up!${NC}"
echo
echo -e "🌐 Start server with ${LCYAN}${pkg_man} run start${NC}"
if [ $skip_debugger_setup != 'true' ]; then
  echo -e "🐞 Start a chrome debugger instance with ${LCYAN}${pkg_man} run debug${NC}"
fi
echo