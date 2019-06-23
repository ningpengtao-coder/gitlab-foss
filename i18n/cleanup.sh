#!/bin/bash
# Clean up the newly patched branch
PATCH_NAME="$1" # name for the patch
DIRECTORY="$2"

# Regenerate the .pot file
# Prettify js files
rake gettext:regenerate && yarn prettier-all-save

# remove the patch file
rm "$PATCH_NAME"

read -r -d ''  << EOM
Vue-i18n: $DIRECTORY directory 

i18n linting for .vue files under the
$DIRECTORY directory
EOM

git commit -m "$MESSAGE"