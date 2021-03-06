#!/bin/bash

git config --global user.email "travis@travis-ci.org"
git config --global user.name "Travis CI"

VERSION=$(pip freeze | grep -ie ucca -e semstr)
git commit -qam "Travis build $TRAVIS_BUILD_NUMBER, $VERSION" || exit 1

URL=`git remote get-url origin | sed "s/github\.com/${GH_TOKEN}@github.com/"`
git remote set-url origin $URL > /dev/null 2>&1

BRANCH=`git rev-parse --abbrev-ref HEAD`
[ $BRANCH == HEAD ] && BRANCH=$TRAVIS_BRANCH
git pull --quiet --rebase origin $BRANCH
git push --quiet --set-upstream origin $BRANCH

