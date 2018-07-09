#!/bin/bash

FORMAT=$1
BRANCH=`git rev-parse --abbrev-ref HEAD`
[ $BRANCH == HEAD ] && BRANCH=$TRAVIS_BRANCH
[ $TRAVIS_PULL_REQUEST == false ] || BRANCH=pr-$TRAVIS_PULL_REQUEST
git config --replace-all remote.origin.fetch +refs/heads/*:refs/remotes/origin/*
git fetch origin ${BRANCH}-sentences
git checkout -b ${BRANCH}-sentences origin/${BRANCH}-sentences
BRANCH=${BRANCH}-$FORMAT

pip install -U 'semstr[amr]'
mkdir tmp
python -m semstr.convert *.pickle -o tmp -f $FORMAT --no-wikification --default-label="label" || exit 1
git checkout --orphan $BRANCH
git reset
git pull origin $BRANCH
rm -f *.*
mv -f tmp/* ./
rmdir tmp
if [ $FORMAT == amr ]; then
  git add *.txt
else
  git add *.$FORMAT
fi

