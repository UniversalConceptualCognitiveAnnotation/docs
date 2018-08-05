#!/bin/bash

FORMAT=$1
BRANCH=`git rev-parse --abbrev-ref HEAD`
[ $BRANCH == HEAD ] && BRANCH=$TRAVIS_BRANCH
[ $TRAVIS_PULL_REQUEST == false ] || BRANCH=pr-$TRAVIS_PULL_REQUEST
git config --replace-all remote.origin.fetch +refs/heads/*:refs/remotes/origin/*
git fetch origin ${BRANCH}-sentences
git checkout -b ${BRANCH}-sentences origin/${BRANCH}-sentences
mkdir sentences
mv $2*.pickle sentences
rm -f *.*
git reset
BRANCH=${BRANCH}-$FORMAT
git fetch origin ${BRANCH}
git checkout -b ${BRANCH} origin/${BRANCH}

pip install -U 'semstr[amr]'
if [ $FORMAT == amr ]; then
  FORMAT=txt
fi
mkdir converted
mv $2*.$FORMAT converted
rm -f *.*
python -m semstr.evaluate converted sentences || exit 1

