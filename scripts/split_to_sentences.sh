#!/bin/base

BRANCH=`git rev-parse --abbrev-ref HEAD`
[ $BRANCH == HEAD ] && BRANCH=$TRAVIS_BRANCH
[ $TRAVIS_PULL_REQUEST == false ] || BRANCH=pr-$TRAVIS_PULL_REQUEST
BRANCH=${BRANCH}-sentences

python -m scripts.standard_to_sentences xml -o . -b || exit 1
git fetch origin $BRANCH
if ! git checkout -b $BRANCH origin/$BRANCH; then
  git checkout --orphan $BRANCH
  git reset
fi
git add *.pickle

