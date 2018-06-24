#!/bin/bash

BRANCH=`git rev-parse --abbrev-ref HEAD`
[ $BRANCH == HEAD ] && BRANCH=$TRAVIS_BRANCH
[ $TRAVIS_PULL_REQUEST == false ] || BRANCH=pr-$TRAVIS_PULL_REQUEST
git config --replace-all remote.origin.fetch +refs/heads/*:refs/remotes/origin/*
git fetch
git checkout -b sentences origin/${BRANCH}-sentences
BRANCH=${BRANCH}-sentences-xml

python -m scripts.pickle_to_standard *.pickle -o . || exit 1
git checkout -b $BRANCH origin/$BRANCH || git checkout --orphan $BRANCH
git reset
git add *.xml

