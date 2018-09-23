#!/bin/bash

BRANCH=`git rev-parse --abbrev-ref HEAD`
[ $BRANCH == HEAD ] && BRANCH=$TRAVIS_BRANCH
[ $TRAVIS_PULL_REQUEST == false ] || BRANCH=pr-$TRAVIS_PULL_REQUEST
git config --replace-all remote.origin.fetch +refs/heads/*:refs/remotes/origin/*
git fetch origin ${BRANCH}-sentences
git checkout -b ${BRANCH}-sentences origin/${BRANCH}-sentences
BRANCH=${BRANCH}-images

pip install 'ucca[visualize]'
mkdir tmp
python -m scripts.visualize --format svg --node-ids $1*.pickle -o tmp || exit 1
pip install scour
for f in tmp/*.svg; do
  scour -i $f -o $f.tmp --enable-viewboxing --enable-id-stripping --enable-comment-stripping --shorten-ids --indent=none
  mv $f.tmp $f -f
done
git checkout --orphan $BRANCH
git reset -q
git pull origin $BRANCH
rm -f $1*.*
mv -f tmp/* ./
rmdir tmp
git add *.svg

