#!/bin/bash
# Creates a patch file from a diff
GLOB="$1" # pattern to diff on
PATCH_NAME="$2"

# TARGET_BRANCH="57969-i18n-linters-eslint-vue"
TARGET_BRANCH="vue-fix-eslint"
SRC_BRANCH="master"

CMD_TARGET="git checkout $TARGET_BRANCH"
eval $CMD_TARGET 

CMD="git diff $SRC_BRANCH..$TARGET_BRANCH -- $GLOB >> $PATCH_NAME.patch"
eval $CMD
