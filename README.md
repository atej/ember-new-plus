## What is this?

A bash scipt to **_quickly_** set up your new ember project for a smooth developer experience in VS Code.

## Quickstart ⚡

1. Create a new ember app

> **NOTE:** Assumes `ember-cli` is installed globally | `npm i -g ember-cli`

```bash
ember new my-app
```
or
```bash
ember new my-app --yarn
```

2. Navigate to your app directory

```bash
cd my-app
```

3. Run this command in your terminal, inside your app's **root** directory.

> **NOTE:** this command executes the `ember-new-plus.sh` bash script without needing to clone the whole [repo](https://github.com/atej/ember-new-plus).

```bash
exec 3<&1;bash <&3 <(curl https://raw.githubusercontent.com/atej/ember-new-plus/master/dist/ember-new-plus.sh 2> /dev/null)
```

4. Follow the prompts and make your selections.

5. After the script does its thing, go to the VS Code extensions tab `⇧⌘X` and type in `@recommended` in the search bar. Install and enable the extensions that show up under 'WORKSPACE RECOMMENDATIONS'.

Done!

## What's set up

🎨 JavaScript linting and formatting with ESlint and Prettier (plus, integration in VS Code- automatic fixing on save, for fixable errors)

👔 CSS linting and formatting with stylelint (plus, integration in VS Code - automatic fixing on save, for fixable errors) ➨ optional

🌊 Tailwind and postcss for utility-first CSS (plus, integration in VS Code - tailwind class name suggestions and sorting) ➨ optional

🐶 Git hooks with husky ➨ optional
- 🧹Linting of staged js, hbs and css files ➨ optional
- 📩 Linting of commit messages to follow [conventional commits](https://www.conventionalcommits.org/)  recommendations ➨ optional

🐞 In-editor debugging with "Debugger for Chrome" ➨ optional
