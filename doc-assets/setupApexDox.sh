#!/bin/sh

# Run this BEFORE running ApexDox so all your files are set up properly.

printf '<link href="assets/styling.css" rel="stylesheet" />' > "doc-assets/main.html"
echo >> "doc-assets/main.html"
npx marked -i README.md --gfm >> "doc-assets/main.html"

npm run updateHighlight