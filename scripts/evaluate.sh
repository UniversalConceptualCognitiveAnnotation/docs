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
git reset -q
BRANCH=${BRANCH}-$FORMAT
git fetch origin ${BRANCH}
git checkout -b ${BRANCH} origin/${BRANCH}

pip install -U 'semstr[amr]'
if [ $FORMAT == amr ]; then
  FORMAT=txt
fi
mkdir converted
if [ $FORMAT == site ]; then
  python -m scripts.site_to_standard $2*.xml -o converted || exit 1
else
  mv $2*.$FORMAT converted
fi
rm -f *.*
python -m semstr.evaluate converted sentences || exit 1
git reset --hard -q

