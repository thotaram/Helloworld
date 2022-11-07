#!/usr/bin/env bash
# user/organisation where repo is hosted and repo name e.g. for owner/reponame:
GH_REPO_USER=thotaram
GH_REPO=Helloworld
GH_TARGET=main
ASSETS_PATH=build
VERSION='01.00.140'
ver=($(echo $VERSION | tr "." "\n"))
MAJOR=${ver[0]}
MINOR=${ver[1]}
echo "Major: ${MAJOR}"
echo "Minor: ${MINOR}"
git add -u
git commit -m "$VERSION release"
git push
res=`curl -H "Accept: application/vnd.github+json" -H "Authorization: Bearer ${GITHUB_PAT}" -X POST https://api.github.com/repos/${GH_REPO_USER}/${GH_REPO}/releases \
-d "
{
  \"tag_name\": \"v$MAJOR.$MINOR\",
  \"target_commitish\": \"$GH_TARGET\",
  \"name\": \"v$MAJOR.$MINOR\",
  \"body\": \"Jenkins Release version $MAJOR.$MINOR\",
  \"draft\": false,
  \"prerelease\": false
}"`
echo Create release result: ${res}
rel_id=`echo ${res} | python -c 'import json,sys;print(json.load(sys.stdin)["id"])'`
echo Release Id: ${rel_id}
for filepath in "$ASSETS_PATH"/*
do
	filename=$(basename $filepath)
	curl -X POST -H "Accept: application/vnd.github+json" -H "Authorization: Bearer ${GITHUB_PAT}" https://uploads.github.com/repos/${GH_REPO_USER}/${GH_REPO}/releases/${rel_id}/assets?name=${filename}\
 --header 'Content-Type: application/json ' --upload-file ${ASSETS_PATH}/${filename}
done




