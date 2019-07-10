GLOB=$1
SOURCE_BRANCH=$2
PROJECT_ID=$3
ACCESS_TOKEN=$4

TARGET_BRANCH="master"

# echo "Access: $ACCESS_TOKEN"
# echo "Project: $PROJECT_ID"

PLUGIN='[eslint-plugin-vue-i18n](https://gitlab.com/ekigbo/eslint-plugin-vue-i18n)'
RELATED_ISSUE="63457"

LABELS="Deliverable,Manage,backstage,frontend,internationalization"
ASSIGNEE_ID="3397881"
# MILESTONE_ID=""

read -r -d '' TITLE << EOM
WIP: Vue-i18n: autofix for '$GLOB' directory 
EOM

read -r -d '' DESCRIPTION << EOM
## What does this MR do?
\n\nExternalizes strings found by "$PLUGIN"
\n\nThis MR externalizes strings in files located under '$GLOB' which have been detected by eslint-plugin-vue-i18n.
\n\n**Note:** 'eslint-plugin-vue-i18n' is not part of our codebase yet but will eventually be added in a separate MR.
\n\n## EE Port
\n\n## What are the relevant issue numbers?
\n\n#$RELATED_ISSUE
EOM

# -d 'milestone_id="$MILESTONE_ID"'
REQ="curl --request POST --header 'PRIVATE-TOKEN: "$ACCESS_TOKEN"' \
-d 'title="$TITLE"'
-d 'description="$DESCRIPTION"'
-d 'assignee_id="$ASSIGNEE_ID"'
-d 'labels="$LABELS"'
-d 'source_branch="$SOURCE_BRANCH"'
-d 'target_branch="$TARGET_BRANCH"'
'https://gitlab.com/api/v4/projects/"$PROJECT_ID"/merge_requests'"

# echo $TITLE
# echo $DESCRIPTION
echo "\n"
echo $REQ
echo "\n"

# eval $REQ