BRANCH=$1

CMD_MASTER="git checkout master"
CMD_BRANCH="git checkout -b $BRANCH"
CMD_PATCH="git apply $BRANCH.patch"

eval $CMD_MASTER && $CMD_BRANCH && $CMD_PATCH
