#!/bin/bash

BRANCH=`git rev-parse --abbrev-ref HEAD`
[ $BRANCH == HEAD ] && BRANCH=$TRAVIS_BRANCH
[ $TRAVIS_PULL_REQUEST == false ] || BRANCH=pr-$TRAVIS_PULL_REQUEST
git config --replace-all remote.origin.fetch +refs/heads/*:refs/remotes/origin/*
git fetch origin ${BRANCH}-sentences
git checkout -b ${BRANCH}-sentences origin/${BRANCH}-sentences
BRANCH=${BRANCH}-sentences-xml

mkdir tmp
python -m scripts.pickle_to_standard *.pickle -o tmp || exit 1
git checkout --orphan $BRANCH
git reset
git pull origin $BRANCH
mv -f tmp/* ./
rmdir tmp
git add *.xml

