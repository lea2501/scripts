#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

### set USAGE message
Help() {
  # Display Help
  echo "Download project artifacts."
  echo ""
  echo "  Syntax: ./downloadAppFileFromBitrise.sh [project] [branch]"
  echo ""
  echo "  Available parameters:"
  echo "    project          -> android | androidtv | ios | androidiot"
  echo "    branch           -> master | develop | staging | uat"
  echo ""
}
if [ -z "$1" ]; then
  Help
  exit 1
fi
if [ -z "$2" ]; then
  Help
  exit 1
fi
### check parameter values
application=(android androidtv ios androidiot)
if [[ " "${application[@]}" " != *" $1 "* ]]; then
  echo "Application: $1"
  echo "$1: not recognized. Valid applications are:"
  echo "${application[@]/%/,}"
  exit 1
fi
branches=(master develop staging uat)
if [[ " "${branches[@]}" " != *" $2 "* ]]; then
  echo "$2: not recognized. Valid branches are:"
  echo "${branches[@]/%/,}"
  exit 1
fi

# Application file configuration
#JENKINS_USER=leandro
#JENKINS_PASS=Lea034245
APP_BRANCH=develop
#APP_BRANCH=uat
# Bitrise API docs: https://devcenter.bitrise.io/api/api-index/
BITRISE_TOKEN=VCBeoFylUSzuNhfOQ5SjStpwcDzlC-LQV_Yrf_TbD8nN_wFzNUTLIv6ddwRzmt79ZrI9tRBhXjk1XFAcyjOwEQ
if [ $1 == "android" ]; then
  BITRISE_APP_SLUG=10271b979205b054
elif [ $1 == "androidtv" ]; then
  BITRISE_APP_SLUG=ba9629d2b45016d3
elif [ $1 == "ios" ]; then
  BITRISE_APP_SLUG=7b9853710dfa6200
elif [ $1 == "androidiot" ]; then
  BITRISE_APP_SLUG=3973d7ff1b606be8
fi
BITRISE_APP_BRANCH=$2
BITRISE_API_BUILD_SLUG_URL="https://api.bitrise.io/v0.1/apps/${BITRISE_APP_SLUG}/builds?branch=${BITRISE_APP_BRANCH}&status=1&limit=1"
BITRISE_APP_BUILD_SLUG=
BITRISE_API_BUILD_ARTIFACTS_URL=

### Get latest application file ###
echo "Downloading latest successful build application file from ${APP_BRANCH} branch..."
### JENKINS ###
#if [ $APP_BRANCH = "develop" ]; then
#while ! curl -OL -u ${JENKINS_USER}:${JENKINS_PASS} "http://10.200.172.73:8080/job/Test-App/job/Android/job/Build/job/Develop/job/Job-BuildAppAndroidFlowAr-Develop-All/lastSuccessfulBuild/artifact/version.txt"; do sleep 3; done
#while ! curl -OL -u ${JENKINS_USER}:${JENKINS_PASS} "http://10.200.172.73:8080/job/Test-App/job/Android/job/Build/job/Develop/job/Job-BuildAppAndroidFlowAr-Develop-All/lastSuccessfulBuild/artifact/${APPPATH}"; do sleep 3; done
#curl -OL -u ${JENKINS_USER}:${JENKINS_PASS} "http://10.200.172.73:8080/job/Test-App/job/Android/job/Build/job/Develop/job/Job-BuildAppAndroidFlowAr-Develop-All/lastSuccessfulBuild/artifact/version.txt"
#curl -OL -u ${JENKINS_USER}:${JENKINS_PASS} "http://10.200.172.73:8080/job/Test-App/job/Android/job/Build/job/Develop/job/Job-BuildAppAndroidFlowAr-Develop-All/lastSuccessfulBuild/artifact/${APPPATH}"
#elif [ $APP_BRANCH = "uat" ]; then
#while ! curl -OL -u ${JENKINS_USER}:${JENKINS_PASS} "http://10.200.172.73:8080/job/Test-App/job/Android/job/Build/job/Uat/job/Job-BuildAppAndroidFlowAr-Uat-Prod/lastSuccessfulBuild/artifact/version.txt"; do sleep 3; done
#while ! curl -OL -u ${JENKINS_USER}:${JENKINS_PASS} "http://10.200.172.73:8080/job/Test-App/job/Android/job/Build/job/Uat/job/Job-BuildAppAndroidFlowAr-Uat-Prod/lastSuccessfulBuild/artifact/${APPPATH}"; do sleep 3; done
#fi
#### BITRISE ###
# Get app build slug
BITRISE_APP_BUILD_SLUG=$(curl -H "Authorization: ${BITRISE_TOKEN}" "${BITRISE_API_BUILD_SLUG_URL}" | jq '.data | .[] | .slug' | tr -d \")
echo "Bitrise application build slug: $BITRISE_APP_BUILD_SLUG"
# Get app build slug artifacts
BITRISE_API_BUILD_ARTIFACTS_URL="https://api.bitrise.io/v0.1/apps/${BITRISE_APP_SLUG}/builds/${BITRISE_APP_BUILD_SLUG}/artifacts"
BITRISE_API_BUILD_ARTIFACTS_SLUGS=($(curl -H "Authorization: ${BITRISE_TOKEN}" "${BITRISE_API_BUILD_ARTIFACTS_URL}" | jq '.data | .[] | .slug' | tr -d \"))
#echo $BITRISE_API_BUILD_ARTIFACTS_SLUGS
printf "%s\n" "${BITRISE_API_BUILD_ARTIFACTS_SLUGS[@]}"

# Get app build slug artifacts download urls and download artifacts
for i in "${BITRISE_API_BUILD_ARTIFACTS_SLUGS[@]}"; do
  :
  # do whatever on $i
  echo "Bitrise application build artifact slug: $i"
  BITRISE_API_BUILD_ARTIFACT_URL="https://api.bitrise.io/v0.1/apps/${BITRISE_APP_SLUG}/builds/${BITRISE_APP_BUILD_SLUG}/artifacts/$i"
  echo "Bitrise application build artifact url: $BITRISE_API_BUILD_ARTIFACT_URL"
  BITRISE_API_BUILD_ARTIFACT_SLUG_TITLE=$(curl -H "Authorization: ${BITRISE_TOKEN}" "${BITRISE_API_BUILD_ARTIFACT_URL}" | jq '.data.title' | tr -d \")
  echo "Bitrise application build artifact slug title: $BITRISE_API_BUILD_ARTIFACT_SLUG_TITLE"
  BITRISE_API_BUILD_ARTIFACT_SLUG_VERSION=$(curl -H "Authorization: ${BITRISE_TOKEN}" "${BITRISE_API_BUILD_ARTIFACT_URL}" | jq '.data.artifact_meta.app_info.version_name' | tr -d \")
  echo "$BITRISE_API_BUILD_ARTIFACT_SLUG_VERSION" >"${BITRISE_API_BUILD_ARTIFACT_SLUG_TITLE}"_version.txt
  if [[ "$BITRISE_API_BUILD_ARTIFACT_SLUG_TITLE" == *"app-flow-prod.apk"* ]]; then
    echo "$BITRISE_API_BUILD_ARTIFACT_SLUG_VERSION" >version.txt
  fi
  BITRISE_API_BUILD_ARTIFACT_SLUG_URL=$(curl -H "Authorization: ${BITRISE_TOKEN}" "${BITRISE_API_BUILD_ARTIFACT_URL}" | jq '.data | .expiring_download_url' | tr -d \")
  echo "Bitrise application build artifact slug url: $BITRISE_API_BUILD_ARTIFACT_SLUG_URL"
  curl --output "$BITRISE_API_BUILD_ARTIFACT_SLUG_TITLE" "$BITRISE_API_BUILD_ARTIFACT_SLUG_URL"
done

APP_VERSION=$(cat version.txt)
echo "Downloaded version is ${APP_VERSION}"
echo "Downloading latest successful build application file from ${APP_BRANCH} branch... DONE"

# Rename files
if [ $1 == "ios" ]; then
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
