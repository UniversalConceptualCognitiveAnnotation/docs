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
if [ $FORMAT == site ]; then
  python -m scripts.standard_to_site $2*.pickle -o tmp || exit 1
else
  python -m semstr.convert $2*.pickle -o tmp -f $FORMAT --no-wikification --default-label="label" || exit 1
fi
git checkout --orphan $BRANCH
git reset -q
git pull origin $BRANCH
rm -f $2*.*
mv -f tmp/* ./
rmdir tmp
if [ $FORMAT == amr ]; then
  FORMAT=txt
fi
git add *.$FORMAT

