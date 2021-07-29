#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

function show_usage() {
  printf "Usage: $0 [options [parameters]]\n"
  printf "\n"
  printf "Mandatory options:\n"
  printf " -p|--project             [android | androidtv | ios | androidiot] (Mandatory)\n"
  printf " -b|--branch              [master | develop | staging | uat] (Mandatory)\n"
  printf "\n"
  printf " -h|--help, Print help\n"

  exit
}

if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
  show_usage
fi
if [[ -z $1 ]]; then
  show_usage
fi

while [ ! -z "$1" ]; do
  case "$1" in
  --project | -p)
    shift
    echo "project: $1"
    PROJECT=$1
    ;;
  --branch | -b)
    shift
    echo "branch: $1"
    BITRISE_APP_BRANCH=$1
    ;;
  *)
    show_usage
    ;;
  esac
  shift
done

### check parameter values
application=(android androidtv ios androidiot)
if [[ " "${application[@]}" " != *" $PROJECT "* ]]; then
  echo "$PROJECT: not recognized. Valid applications are:"
  echo "${application[@]/%/,}"
  exit 1
fi
branches=(master develop staging uat)
if [[ " "${branches[@]}" " != *" $BITRISE_APP_BRANCH "* ]]; then
  echo "$BITRISE_APP_BRANCH: not recognized. Valid branches are:"
  echo "${branches[@]/%/,}"
  exit 1
fi

# Application file configuration
#JENKINS_USER=leandro
#JENKINS_PASS=Lea034245
# Bitrise API docs: https://devcenter.bitrise.io/api/api-index/
BITRISE_TOKEN=VCBeoFylUSzuNhfOQ5SjStpwcDzlC-LQV_Yrf_TbD8nN_wFzNUTLIv6ddwRzmt79ZrI9tRBhXjk1XFAcyjOwEQ
if [ "$PROJECT" == "android" ]; then
  BITRISE_APP_SLUG=10271b979205b054
elif [ "$PROJECT" == "androidtv" ]; then
  BITRISE_APP_SLUG=ba9629d2b45016d3
elif [ "$PROJECT" == "ios" ]; then
  BITRISE_APP_SLUG=7b9853710dfa6200
elif [ "$PROJECT" == "androidiot" ]; then
  BITRISE_APP_SLUG=3973d7ff1b606be8
fi
BITRISE_API_BUILD_SLUG_URL="https://api.bitrise.io/v0.1/apps/${BITRISE_APP_SLUG}/builds?branch=${BITRISE_APP_BRANCH}&status=1&limit=1"
BITRISE_APP_BUILD_SLUG=
BITRISE_API_BUILD_ARTIFACTS_URL=

### Get latest application file ###
echo "Downloading latest successful build application file from ${BITRISE_APP_BRANCH} branch..."
#### BITRISE ###
# Get app build slug
BITRISE_APP_BUILD_SLUG=$(curl -sS -H "Authorization: ${BITRISE_TOKEN}" "${BITRISE_API_BUILD_SLUG_URL}" | jq '.data | .[] | .slug' | tr -d \")
echo "Bitrise application build slug: $BITRISE_APP_BUILD_SLUG"
# Get app build slug artifacts
BITRISE_API_BUILD_ARTIFACTS_URL="https://api.bitrise.io/v0.1/apps/${BITRISE_APP_SLUG}/builds/${BITRISE_APP_BUILD_SLUG}/artifacts"
BITRISE_API_BUILD_ARTIFACTS_SLUGS=($(curl -sS -H "Authorization: ${BITRISE_TOKEN}" "${BITRISE_API_BUILD_ARTIFACTS_URL}" | jq '.data | .[] | .slug' | tr -d \"))
#echo $BITRISE_API_BUILD_ARTIFACTS_SLUGS
printf "%s\n" "${BITRISE_API_BUILD_ARTIFACTS_SLUGS[@]}"

# Get app build slug artifacts download urls and download artifacts
for i in "${BITRISE_API_BUILD_ARTIFACTS_SLUGS[@]}"; do
  :
  # do whatever on $i
  echo "Bitrise application build artifact slug: $i"
  BITRISE_API_BUILD_ARTIFACT_URL="https://api.bitrise.io/v0.1/apps/${BITRISE_APP_SLUG}/builds/${BITRISE_APP_BUILD_SLUG}/artifacts/$i"
  echo "Bitrise application build artifact url: $BITRISE_API_BUILD_ARTIFACT_URL"
  BITRISE_API_BUILD_ARTIFACT_SLUG_TITLE=$(curl -sS -H "Authorization: ${BITRISE_TOKEN}" "${BITRISE_API_BUILD_ARTIFACT_URL}" | jq '.data.title' | tr -d \")
  echo "Bitrise application build artifact slug title: $BITRISE_API_BUILD_ARTIFACT_SLUG_TITLE"
  if [ "$PROJECT" == "ios" ]; then
    BITRISE_API_BUILD_ARTIFACT_SLUG_VERSION=$(curl -sS -H "Authorization: ${BITRISE_TOKEN}" "${BITRISE_API_BUILD_ARTIFACT_URL}" | jq '.data.artifact_meta.app_info.version' | tr -d \")
  else
    BITRISE_API_BUILD_ARTIFACT_SLUG_VERSION=$(curl -sS -H "Authorization: ${BITRISE_TOKEN}" "${BITRISE_API_BUILD_ARTIFACT_URL}" | jq '.data.artifact_meta.app_info.version_name' | tr -d \")
  fi
  echo "$BITRISE_API_BUILD_ARTIFACT_SLUG_VERSION" >"${BITRISE_API_BUILD_ARTIFACT_SLUG_TITLE}"_version.txt
  if [[ "$BITRISE_API_BUILD_ARTIFACT_SLUG_TITLE" == *"app-flow-prod.apk"* || "$BITRISE_API_BUILD_ARTIFACT_SLUG_TITLE" == *"Flow_Distribution.ipa"* ]]; then
    echo "$BITRISE_API_BUILD_ARTIFACT_SLUG_VERSION" >version.txt
  fi
  BITRISE_API_BUILD_ARTIFACT_SLUG_URL=$(curl -sS -H "Authorization: ${BITRISE_TOKEN}" "${BITRISE_API_BUILD_ARTIFACT_URL}" | jq '.data | .expiring_download_url' | tr -d \")
  echo "Bitrise application build artifact slug url: $BITRISE_API_BUILD_ARTIFACT_SLUG_URL"
  curl --output "$BITRISE_API_BUILD_ARTIFACT_SLUG_TITLE" "$BITRISE_API_BUILD_ARTIFACT_SLUG_URL"
  echo "$BITRISE_API_BUILD_ARTIFACT_SLUG_TITLE: $BITRISE_API_BUILD_ARTIFACT_SLUG_URL"
done

APP_VERSION=$(cat version.txt)
echo "Downloaded version is ${APP_VERSION}"
echo "Downloading latest successful build application file from ${BITRISE_APP_BRANCH} branch... DONE"

# Rename files
if [ "$PROJECT" == "ios" ]; then
  FILE="Flow_Distribution.ipa"
  if [ -f "$FILE" ]; then
    mv $FILE flow.ipa
  fi
  FILE="Flow_Distribution_Testflight.ipa"
  if [ -f "$FILE" ]; then
    mv $FILE flow_os.ipa
  fi
  FILE="Dibox_Distribution.ipa"
  if [ -f "$FILE" ]; then
    mv $FILE dibox.ipa
  fi
  FILE="Dibox_Distribution_Testflight.ipa"
  if [ -f "$FILE" ]; then
    mv $FILE dibox_os.ipa
  fi
fi
