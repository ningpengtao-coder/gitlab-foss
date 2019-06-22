GLOB="$1" # pattern to diff on
PATCH_NAME="$2" # name for the patch

echo "Creating patch $PATCH_NAME from dir $GLOB"

PATCH="sh ./i18n/patcher.sh $GLOB $PATCH_NAME"
eval $PATCH

BRANCH="sh ./i18n/new-branch.sh $PATCH_NAME"
eval $BRANCH

