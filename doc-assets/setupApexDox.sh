#!/bin/sh

# Run this BEFORE running ApexDox so all your files are set up properly.
echo "README to main"
printf '<link href="assets/styling.css" rel="stylesheet" />' > "doc-assets/main.html"
echo >> "doc-assets/main.html"
npx marked -i README.md --gfm >> "doc-assets/main.html"

sed -i '' 's|src="doc-assets/assets|class="readmeimage" src="./assets|g' doc-assets/main.html
sed -i '' 's|CHANGELOG.md|changes.html|g' doc-assets/main.html

echo "TH docs to Dox page"
printf '<link href="assets/styling.css" rel="stylesheet" />' > "doc-assets/assets/triggerhandlerdocs.html"
echo >> "doc-assets/assets/triggerhandlerdocs.html"
npx marked -i doc-assets/assets/triggerhandlerdocs.md --gfm >> "doc-assets/assets/triggerhandlerdocs.html"

echo "Changelog to Dox page"
printf '<link href="assets/styling.css" rel="stylesheet" />' > "doc-assets/assets/changes.html"
echo >> "doc-assets/assets/changes.html"
npx marked -i changelog.md --gfm >> "doc-assets/assets/changes.html"

npm run updateHighlight