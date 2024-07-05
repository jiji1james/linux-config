#!/usr/bin/env bash

# Checkout Debt Manager Code
cd $HOME
mkdir -p $HOME/debtmanager/cloud
mkdir -p $HOME/debtmanager/onprem

function checkoutGitRepository {
    repoName=$1
    parentPath=$2

    checkoutPath="$parentPath/$repoName"

    echo ">>>  Git Repo: $repoName Checkout Path: $checkoutPath"

    if [[ -d $checkoutPath ]] ; then
        echo ">> Update the repo"
        cd $checkoutPath
        git stash
        git reset --hard
        git fetch --prune
        git pull
    else
        echo ">> Clone the repo"
        cd $parentPath
        git clone "git@bitbucket.org:cr-software/$repoName.git"
    fi

    echo ""
}

export checkout="N"
echo ""
read -p "Checkout Callout Services (Y/N): " checkout
if [[ "$checkout" == "Y" ]]; then
	mkdir -p $HOME/crs/cos
	checkoutGitRepository callout-service $HOME/crs/cos
fi

checkout="N"
echo ""
read -p "Checkout Communicator (Y/N): " checkout
if [[ "$checkout" == "Y" ]]; then
	mkdir -p $HOME/crs/comm
	checkoutGitRepository cnr-comm-service $HOME/crs/comm
	checkoutGitRepository cnr-comm-ui $HOME/crs/comm
fi

checkout="N"
echo ""
read -p "Checkout Debt Manager for Cloud (Y/N): " checkout
if [[ "$checkout" == "Y" ]]; then
	checkoutGitRepository crsj2ee $HOME/debtmanager/cloud
	checkoutGitRepository browser-client $HOME/debtmanager/cloud
	checkoutGitRepository db-postgres $HOME/debtmanager/cloud
	checkoutGitRepository db-sqlserver $HOME/debtmanager/cloud
	checkoutGitRepository db-oracle $HOME/debtmanager/cloud
	checkoutGitRepository environment $HOME/debtmanager/cloud
	checkoutGitRepository etl $HOME/debtmanager/cloud
	checkoutGitRepository reports $HOME/debtmanager/cloud
	checkoutGitRepository configuration-management $HOME/debtmanager/cloud
fi

checkout="N"
echo ""
read -p "Checkout Debt Manager for OnPrem (Y/N): " checkout
if [[ "$checkout" == "Y" ]]; then
	checkoutGitRepository crsj2ee $HOME/debtmanager/onprem
	checkoutGitRepository browser-client $HOME/debtmanager/onprem
	checkoutGitRepository environment $HOME/debtmanager/onprem
	checkoutGitRepository configuration-management $HOME/debtmanager/onprem
	checkoutGitRepository db-sqlserver $HOME/debtmanager/onprem
fi

checkout="N"
echo ""
read -p "Checkout Debt Manager Runtime Tools (Y/N): " checkout
if [[ "$checkout" == "Y" ]]; then
	checkoutGitRepository dm-tomcat $HOME/debtmanager
	checkoutGitRepository dm-jboss $HOME/debtmanager
	checkoutGitRepository dm-activemq-artemis $HOME/debtmanager
fi
