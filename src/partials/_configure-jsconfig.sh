echo
echo -e "⚙️  ${YELLOW}Creating a jsconfig file... ${NC}"
> "jsconfig.json"

echo '{
  "compilerOptions": { "target": "es6", "experimentalDecorators": true },
  "exclude": [
    "node_modules",
    "bower_components",
    "tmp",
    "vendor",
    ".git",
    "dist"
  ]
}' >> jsconfig.json
echo