#!/bin/bash

##################################################################################
#
#       Author: Adnan Asif
#       Date:   24/0/2024
#       version: v1
#
#       Repos migration tool
#
#       This script will migrate your bitbucket
#       repositories to github, You just need to 
#       create blank[no readme, no template etc..] github repos with same names,
#       
##################################################################################

# Bitbucket credentials
BITBUCKET_USERNAME="myusername"
BITBUCKET_WORKSPACE_ID="myusername" # Use your username if you do not have workspace id
BITBUCKET_REPO_LIST=("repo1" "repo2" "repo3") # Add your Bitbucket repos here

# GitHub credentials
GITHUB_ORG="myusername" # Use your username if not an organization

for REPO in "${BITBUCKET_REPO_LIST[@]}"; do
    echo "Migrating $REPO..."

    # Clone the Bitbucket repository

    git clone --mirror "https://${BITBUCKET_USERNAME}@bitbucket.org/${BITBUCKET_WORKSPACE_ID}/${REPO}.git" || { echo "Failed to clone $REPO"; continue; }

    # Change directory to the cloned repo
    cd "$REPO.git" || { echo "Failed to enter directory $REPO.git"; continue; }

    # Add GitHub remote
    git remote add github "https://github.com/${GITHUB_ORG}/${REPO}.git"

    # Push to GitHub
    git push --mirror github || { echo "Failed to push $REPO to GitHub"; cd ..; continue; }

    # Cleanup
    cd ..
    rm -rf "$REPO.git"

    echo "Successfully migrated $REPO!"
done

echo "Migration completed."
