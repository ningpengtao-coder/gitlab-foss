GLOB="$1" # pattern to diff on
PATCH_NAME="$2" # name for the patch
PROJECT_ID="$3"
TARGET_REF="$4"
ACCESS_TOKEN="$5"

echo "Creating patch $PATCH_NAME from dir $GLOB"

PATCH="sh ./bin/i18n/create-patch.sh $GLOB $PATCH_NAME"
eval $PATCH

# Just chill
sleep 5

BRANCH="sh ./bin/i18n/create-branch.sh $PATCH_NAME $PROJECT_ID $TARGET_REF $ACCESS_TOKEN"
eval $BRANCH

# Just chill
sleep 5

BRANCH="sh ./bin/i18n/create-mr.sh $GLOB $PATCH_NAME $PROJECT_ID $ACCESS_TOKEN"
eval $BRANCH

# Just chill
sleep 5

# run clean up functions
CLEANUP="sh ./bin/i18n/cleanup.sh $GLOB $PATCH_NAME"
eval $CLEANUP