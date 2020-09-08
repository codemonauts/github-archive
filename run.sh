#! /usr/bin/env bash
set -eu

if [ -z $1 ]; then
    echo "Please run with a valid GitHub URL as first parameter"
    exit 1
fi

if [[ $1 != git@github.com:* ]]; then
    echo "Please run with a valid GitHub URL as first parameter"
    exit 1
fi

URL=$1
TARGET=$(mktemp -d -t ci-XXXXXXXXXX)
START=`pwd`

git clone $URL $TARGET
cd $TARGET

# Get all branches
remote=origin ; for brname in `git branch -r | grep $remote | grep -v master | grep -v HEAD | awk '{gsub(/^[^\/]+\//,"",$1); print $1}'`; do git branch --track $brname $remote/$brname || true; done 2>/dev/null
git fetch --all
git pull --all

NAME=`git remote -v | grep fetch | cut -d"/" -f2 | cut -d"." -f1`

tar -zcf $START/$NAME.tar.gz .
cd -
rm -rf $TARGET
