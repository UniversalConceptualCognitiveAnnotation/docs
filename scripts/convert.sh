#!/bin/bash

FORMAT=$1
BRANCH=`git rev-parse --abbrev-ref HEAD`
[ $BRANCH == HEAD ] && BRANCH=$TRAVIS_BRANCH
[ $TRAVIS_PULL_REQUEST == false ] || BRANCH=pr-$TRAVIS_PULL_REQUEST
git config --replace-all remote.origin.fetch +refs/heads/*:refs/remotes/origin/*
git fetch
git checkout -b sentences origin/${BRANCH}-sentences
BRANCH=${BRANCH}-$FORMAT

pip install -U 'semstr[amr]'
python -m semstr.convert *.pickle -o . -f $FORMAT --no-wikification --default-label="label" || exit 1
git checkout -b $BRANCH origin/$BRANCH || git checkout --orphan $BRANCH
git reset
git add *.$FORMAT

