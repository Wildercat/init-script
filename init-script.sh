#!/bin/bash

# originally forked from https://gist.github.com/robwierzbowski/5430952/
# Create and push to a new github repo from the command line.  

# Gather constant vars
CURRENTDIR=${PWD##*/}
GITHUBUSER=$(git config github.userName)

# ------------ ATTN: CONFIGURATION REQUIRED ------------
# You will need to create a file with either your password or an api key and point to it here
APIKEY=$(cat api_key)
# Storing your password in plaintext isn't great security-wise, you can make an api key here: https://github.com/settings/tokens
# just make sure to check "repo" to give that key the right permissions

# ------------ ATTN: CONFIGURATION REQUIRED ------------
# Replace my username with your own
USER=wildercat

# Get user input
echo "New directory/repo name:"
read REPONAME
echo "Repo Description:"
read DESCRIPTION

echo "Here we go..."

# Curl some json to the github API 
curl -u ${USER}:${APIKEY} https://api.github.com/user/repos -d "{\"name\": \"${REPONAME:-${CURRENTDIR}}\", \"description\": \"${DESCRIPTION}\", \"private\": false, \"has_issues\": true, \"has_downloads\": true, \"has_wiki\": false}"

# Create new directory in your development or sites directory with same name as repo
# ------------ ATTN: CONFIGURATION REQUIRED ------------
# Mine is ~dev/, you'll need to change it to wherever your dir is
mkdir ~/dev/${REPONAME}

# git init in new dir
# ------------ ATTN: CONFIGURATION REQUIRED ------------
# need to change your folder here as well
cd ~/dev/${REPONAME}
git init
# Add new repo as remote
git remote add origin https://github.com/${USER:-${GITHUBUSER}}/${REPONAME}.git
# make a readme and push it to master
echo "# init" >> README.md
git add README.md
git commit -m "initial commit"
git push origin master

# Enable Github Pages hosting for master branch
curl -u ${USER}:${APIKEY} https://api.github.com/repos/${USER}/${REPONAME}/pages --header "Accept: application/vnd.github.switcheroo-preview+json" -d "{\"source\": {\"branch\": \"master\"}}"

# create and checkout dev branch
git checkout -b dev

# ORIGINAL CODE
# # Set the freshly created repo to the origin and push
# # You'll need to have added your public key to your github account
# git remote set-url origin git@github.com:${USER:-${GITHUBUSER}}/${REPONAME:-${CURRENTDIR}}.git
# git push --set-upstream origin master
