#!/bin/bash

FORMAT=$1
BRANCH=`git rev-parse --abbrev-ref HEAD`
[ $BRANCH == HEAD ] && BRANCH=$TRAVIS_BRANCH
git config --replace-all remote.origin.fetch +refs/heads/*:refs/remotes/origin/*
git fetch
git checkout -b $FORMAT origin/${BRANCH}-$FORMAT
BRANCH=${BRANCH}-images

pip install -U semstr
python -m semstr.convert *.pickle -o . -f $FORMAT || exit 1
git checkout -b $BRANCH origin/$BRANCH || git checkout --orphan $BRANCH
git reset
git add *.$FORMAT

