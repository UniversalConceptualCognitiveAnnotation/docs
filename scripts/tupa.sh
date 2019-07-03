#!/bin/bash

BRANCH=`git rev-parse --abbrev-ref HEAD`
[ $BRANCH == HEAD ] && BRANCH=$TRAVIS_BRANCH
[ $TRAVIS_PULL_REQUEST == false ] || BRANCH=pr-$TRAVIS_PULL_REQUEST
git config --replace-all remote.origin.fetch +refs/heads/*:refs/remotes/origin/*
git fetch origin ${BRANCH}-sentences
git checkout -b ${BRANCH}-sentences origin/${BRANCH}-sentences

pip install tupa
export SPACY_MODEL=en_core_web_sm
python -m spacy download $SPACY_MODEL
python -m tupa -t *.pickle -I 1 -c noop -v $*

