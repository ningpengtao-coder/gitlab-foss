BRANCH_NAME=$1
PROJECT_ID=$2
TARGET_REF=$3
ACCESS_TOKEN=$4

CMD_MASTER="git checkout master"
CMD_BRANCH="git checkout -b $BRANCH_NAME"
CMD_PATCH="git apply $BRANCH_NAME.patch"
# CMD_UPSTREAM="
# curl --request POST --header \"PRIVATE-TOKEN: $ACCESS_TOKEN\" https://gitlab.com/api/v4/projects/$PROJECT_ID/repository/branches?branch=$BRANCH_NAME&ref=$TARGET_REF
# "

eval $CMD_MASTER && $CMD_BRANCH && $CMD_PATCH
# echo $CMD_UPSTREAM

# eval $CMD_UPSTREAM