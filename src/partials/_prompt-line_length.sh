# Max Line Length Prompt
finished=false
while ! $finished; do
  read -p "🔢 What max line length do you want to prefer? (Recommendation: 80) "
  echo
  if [[ $REPLY =~ ^[0-9]{2,3}$ ]]; then
    max_len_val=$REPLY
    finished=true
    echo
  else
    echo -e "${RED}Please choose a max length of two or three digits, e.g. 80 or 100 or 120${NC}"
  fi
done