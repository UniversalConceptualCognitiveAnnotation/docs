#!/bin/base

BRANCH=`git rev-parse --abbrev-ref HEAD`
[ $BRANCH == HEAD ] && BRANCH=$TRAVIS_BRANCH
[ $TRAVIS_PULL_REQUEST == false ] || BRANCH=pr-$TRAVIS_PULL_REQUEST
BRANCH=${BRANCH}-sentences

if [ $# -lt 1 ]; then
  TEMP_DIR=tmp
  mkdir $TEMP_DIR
  python -m scripts.standard_to_sentences xml -o $TEMP_DIR -b || exit 1
else
  TEMP_DIR=$1
  [ -d $TEMP_DIR ] || exit 1
fi
git checkout --orphan $BRANCH
git reset -q
git pull origin $BRANCH
rm -f *.*
mv -f $TEMP_DIR/* ./
rmdir $TEMP_DIR
git add *.pickle

