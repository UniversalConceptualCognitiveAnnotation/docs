#!/bin/base

BRANCH=`git rev-parse --abbrev-ref HEAD`
[ $BRANCH == HEAD ] && BRANCH=$TRAVIS_BRANCH
[ $TRAVIS_PULL_REQUEST == false ] || BRANCH=pr-$TRAVIS_PULL_REQUEST
BRANCH=${BRANCH}-sentences

python -m scripts.standard_to_sentences xml -o . -b || exit 1
git checkout -b $BRANCH origin/$BRANCH || git checkout --orphan $BRANCH
git reset
git add *.pickle

