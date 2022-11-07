#!/usr/bin/env bash
﻿
# user/organisation where repo is hosted and repo name e.g. for owner/reponame:
ASSETS_PATH=build
VERSION='2.0.9'
git add -u
git commit -m "$VERSION release"
git push
res=`curl -H "Accept: application/vnd.github+json" -H "Authorization: Bearer ${GITHUB_PAT}" -X POST https://api.github.com/repos/thotaram/Helloworld/releases \
-d "
{
  \"tag_name\": \"v$VERSION\",
  \"target_commitish\": \"main\",
  \"name\": \"v$VERSION\",
  \"body\": \"Jenkins Release version $VERSION\",
  \"draft\": false,
  \"prerelease\": false
}"`
echo Create release result: ${res}
rel_id=`echo ${res} | python -c 'import json,sys;print(json.load(sys.stdin)["id"])'`
echo Release Id: ${rel_id}
for filepath in "$ASSETS_PATH"/*
do
	filename=$(basename $filepath)
	curl -X POST -H "Accept: application/vnd.github+json" -H "Authorization: Bearer ${GITHUB_PAT}" https://uploads.github.com/repos/thotaram/Helloworld/releases/${rel_id}/assets?name=${filename}\
 --header 'Content-Type: application/json ' --upload-file ${ASSETS_PATH}/${filename}
done




