#!/bin/bash

pip install 'ucca[visualize]'
mkdir ${DATASET}_sentences
python -m scripts.standard_to_sentences $DATASET -o ${DATASET}_sentences -b || exit 1
python -m scripts.visualize ${DATASET}_sentences -o $DATASET || exit 1
git config --global user.email "travis@travis-ci.org"
git config --global user.name "Travis CI"
git checkout -b images origin/images || git checkout --orphan images
git add $DATASET/*.png
UCCA_VERSION=$(pip freeze | grep -i ucca | head -1)
git commit -m "Travis build: $TRAVIS_BUILD_NUMBER $UCCA_VERSION [ci skip]" || exit 1
URL=`git remote get-url origin | sed "s/github\.com/${GH_TOKEN}@github.com/"`
git remote set-url origin $URL > /dev/null 2>&1
git push --quiet --set-upstream origin images
