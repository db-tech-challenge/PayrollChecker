#!/bin/bash

mkdir -p docs

cp html/index.html docs/index.html
cp html/.nojekyll docs/.nojekyll
cp html/_headers docs/_headers
cp data/tasks.json docs/tasks.json
cp data/manual-tests.json docs/manual-tests.json

for team in "alpha" "beta" "gamma" "delta" "epsilon" "zeta" "omega" ; do
  cp "html/team.html" "docs/${team}.html"
done

for id in {1..9}; do
  cp "html/task.html" "docs/task-0${id}.html"
done

for id in {10..11}; do
  cp "html/task.html" "docs/task-${id}.html"
done

cp -r target/* docs/

git add docs/*