#!/bin/base

BRANCH=`git rev-parse --abbrev-ref HEAD`
[ $BRANCH == HEAD ] && BRANCH=$TRAVIS_BRANCH
[ $TRAVIS_PULL_REQUEST == false ] || BRANCH=pr-$TRAVIS_PULL_REQUEST
BRANCH=${BRANCH}-sentences

mkdir tmp
python -m scripts.standard_to_sentences xml -o tmp -b || exit 1
git checkout --orphan $BRANCH
git reset -q
git pull origin $BRANCH
rm -f *.*
mv -f tmp/* ./
rmdir tmp
git add *.pickle

