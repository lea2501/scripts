#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

### set USAGE message
Help()
{
  # Display Help
  echo "Download application files."
  echo ""
  echo "  Syntax: ./downloadAppFileFromJenkins.sh [application] [branch]"
  echo ""
  echo "  Available parameters:"
  echo "    application      -> android | androidtv | ios"
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
application=(android androidtv ios);
if [[ " "${application[@]}" " != *" $1 "* ]] ;then
    echo "Application: $1"
    echo "$1: not recognized. Valid applications are:"
    echo "${application[@]/%/,}"
    exit 1
fi
branches=(master develop staging uat);
if [[ " "${branches[@]}" " != *" $2 "* ]] ;then
    echo "$2: not recognized. Valid branches are:"
    echo "${branches[@]/%/,}"
    exit 1
fi

# Application file configuration
JENKINS_USER=leandro
JENKINS_PASS=Lea034245
APPLICATION=$1
APP_BRANCH=$2


### Get latest application file ###
echo "Downloading latest successful build application file from ${APP_BRANCH} branch..."
### JENKINS ###
if [ $APPLICATION = "android" ]; then
  if [ $APP_BRANCH = "develop" ]; then
    while ! curl -OL -u ${JENKINS_USER}:${JENKINS_PASS} "http://10.200.172.73:8080/job/Test-App/job/Android/job/Build/job/Develop/job/Job-BuildAppAndroidFlowAr-Develop-All/lastSuccessfulBuild/artifact/version.txt"; do sleep 3; done
    while ! curl -OL -u ${JENKINS_USER}:${JENKINS_PASS} "http://10.200.172.73:8080/job/Test-App/job/Android/job/Build/job/Develop/job/Job-BuildAppAndroidFlowAr-Develop-All/lastSuccessfulBuild/artifact/${APPPATH}"; do sleep 3; done
    #curl -OL -u ${JENKINS_USER}:${JENKINS_PASS} "http://10.200.172.73:8080/job/Test-App/job/Android/job/Build/job/Develop/job/Job-BuildAppAndroidFlowAr-Develop-All/lastSuccessfulBuild/artifact/version.txt"
    #curl -OL -u ${JENKINS_USER}:${JENKINS_PASS} "http://10.200.172.73:8080/job/Test-App/job/Android/job/Build/job/Develop/job/Job-BuildAppAndroidFlowAr-Develop-All/lastSuccessfulBuild/artifact/${APPPATH}"
  elif [ $APP_BRANCH = "uat" ]; then
    while ! curl -OL -u ${JENKINS_USER}:${JENKINS_PASS} "http://10.200.172.73:8080/job/Test-App/job/Android/job/Build/job/Uat/job/Job-BuildAppAndroidFlowAr-Uat-Prod/lastSuccessfulBuild/artifact/version.txt"; do sleep 3; done
    while ! curl -OL -u ${JENKINS_USER}:${JENKINS_PASS} "http://10.200.172.73:8080/job/Test-App/job/Android/job/Build/job/Uat/job/Job-BuildAppAndroidFlowAr-Uat-Prod/lastSuccessfulBuild/artifact/${APPPATH}"; do sleep 3; done
  fi
elif [ $APPLICATION = "androidtv" ]; then
  if [ $APP_BRANCH = "develop" ]; then
    while ! curl -OL -u ${JENKINS_USER}:${JENKINS_PASS} "http://10.200.172.73:8080/job/Test-App/job/AndroidTv/job/Build/job/Develop/job/Job-BuildAppAndroidTvFlowAr-Develop-Develop/lastSuccessfulBuild/artifact/version.txt"; do sleep 3; done
    while ! curl -OL -u ${JENKINS_USER}:${JENKINS_PASS} "http://10.200.172.73:8080/job/Test-App/job/AndroidTv/job/Build/job/Develop/job/Job-BuildAppAndroidTvFlowAr-Develop-Develop/lastSuccessfulBuild/artifact/${APPPATH}"; do sleep 3; done
    #curl -OL -u ${JENKINS_USER}:${JENKINS_PASS} "http://10.200.172.73:8080/job/Test-App/job/Android/job/Build/job/Develop/job/Job-BuildAppAndroidFlowAr-Develop-All/lastSuccessfulBuild/artifact/version.txt"
    #curl -OL -u ${JENKINS_USER}:${JENKINS_PASS} "http://10.200.172.73:8080/job/Test-App/job/Android/job/Build/job/Develop/job/Job-BuildAppAndroidFlowAr-Develop-All/lastSuccessfulBuild/artifact/${APPPATH}"
  elif [ $APP_BRANCH = "uat" ]; then
    while ! curl -OL -u ${JENKINS_USER}:${JENKINS_PASS} "http://10.200.172.73:8080/job/Test-App/job/AndroidTv/job/Build/job/Develop/job/Job-BuildAppAndroidTvFlowAr-Develop-Develop/lastSuccessfulBuild/artifact/version.txt"; do sleep 3; done
    while ! curl -OL -u ${JENKINS_USER}:${JENKINS_PASS} "http://10.200.172.73:8080/job/Test-App/job/AndroidTv/job/Build/job/Develop/job/Job-BuildAppAndroidTvFlowAr-Develop-Develop/lastSuccessfulBuild/artifact/${APPPATH}"; do sleep 3; done
  #fi
elif [ $APPLICATION = "ios" ]; then
  if [ $APP_BRANCH = "staging" ]; then
    while ! curl -OL -u ${JENKINS_USER}:${JENKINS_PASS} "http://10.200.172.73:8080/job/Test-App/job/iOS/job/Build/job/Staging/job/Job-BuildAppIosFlowAr-Staging-Prod/lastSuccessfulBuild/artifact/version.txt"; do sleep 3; done
    while ! curl -OL -u ${JENKINS_USER}:${JENKINS_PASS} "http://10.200.172.73:8080/job/Test-App/job/iOS/job/Build/job/Staging/job/Job-BuildAppIosFlowAr-Staging-Prod/lastSuccessfulBuild/artifact/flow.ipa"; do sleep 3; done
    #curl -OL -u ${JENKINS_USER}:${JENKINS_PASS} "http://10.200.172.73:8080/job/Test-App/job/iOS/job/Build/job/Staging/job/Job-BuildAppIosFlowAr-Staging-Prod/lastSuccessfulBuild/artifact/version.txt"
    #curl -OL -u ${JENKINS_USER}:${JENKINS_PASS} "http://10.200.172.73:8080/job/Test-App/job/iOS/job/Build/job/Staging/job/Job-BuildAppIosFlowAr-Staging-Prod/lastSuccessfulBuild/artifact/flow.ipa"
  elif [ $APP_BRANCH = "develop" ]; then
    curl -OL -u ${JENKINS_USER}:${JENKINS_PASS} "http://10.200.172.73:8080/job/Test-App/job/iOS/job/Build/job/Develop/job/Job-BuildAppIosFlowAr-Develop-Prod/lastSuccessfulBuild/artifact/version.txt"
    curl -OL -u ${JENKINS_USER}:${JENKINS_PASS} "http://10.200.172.73:8080/job/Test-App/job/iOS/job/Build/job/Develop/job/Job-BuildAppIosFlowAr-Develop-Prod/lastSuccessfulBuild/artifact/flow.ipa"
 fi
fi

APP_VERSION=$(cat version.txt)
echo "Downloaded version is ${APP_VERSION}"
echo "Downloading latest successful build application file from ${APP_BRANCH} branch... DONE"