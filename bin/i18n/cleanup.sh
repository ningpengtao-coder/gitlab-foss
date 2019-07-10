#!/bin/bash
# Clean up the newly patched branch
DIRECTORY="$1"
PATCH_NAME="$2" # name for the patch

echo "Cleaning up $PATCH_NAME"
git checkout "$PATCH_NAME"

# Regenerate the .pot file
# Prettify js files
echo "rake gettext:regenerate"
rake gettext:regenerate 

echo "yarn prettier-all-save"
yarn prettier-all-save

# remove the patch file
rm "$PATCH_NAME.patch"

read -r -d '' MESSAGE << EOM
Vue-i18n: $DIRECTORY directory 

i18n linting for .vue files under the
$DIRECTORY directory
EOM

git add ./app ./locale
git commit -m "$MESSAGE"