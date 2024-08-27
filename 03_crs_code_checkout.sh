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

echo ""
read -p "Checkout Callout Services (Y/N): " coscheckout
read -p "Checkout Communicator (Y/N): " commcheckout
read -p "Checkout Debt Manager for Cloud (Y/N): " cloudcheckout
read -p "Checkout Debt Manager for OnPrem (Y/N): " onpremcheckout
read -p "Checkout Debt Manager Runtime Tools (Y/N): " toolscheckout
read -p "Checkout Debt Manager Libraries (Y/N): " libcheckout

if [[ "$coscheckout" == "Y" ]]; then
	mkdir -p $HOME/crs/cos
	checkoutGitRepository callout-service $HOME/crs/cos
fi

echo ""
if [[ "$commcheckout" == "Y" ]]; then
	mkdir -p $HOME/crs/comm
	checkoutGitRepository cnr-comm-service $HOME/crs/comm
	checkoutGitRepository cnr-comm-ui $HOME/crs/comm
fi

echo ""
if [[ "$cloudcheckout" == "Y" ]]; then
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

echo ""
if [[ "$onpremcheckout" == "Y" ]]; then
	checkoutGitRepository crsj2ee $HOME/debtmanager/onprem
	checkoutGitRepository browser-client $HOME/debtmanager/onprem
	checkoutGitRepository environment $HOME/debtmanager/onprem
	checkoutGitRepository configuration-management $HOME/debtmanager/onprem
	checkoutGitRepository db-sqlserver $HOME/debtmanager/onprem
fi

echo ""
if [[ "$toolscheckout" == "Y" ]]; then
	checkoutGitRepository dm-tomcat $HOME/debtmanager
	checkoutGitRepository dm-jboss $HOME/debtmanager
	checkoutGitRepository dm-activemq-artemis $HOME/debtmanager
fi

echo ""
if [[ "$libcheckout" == "Y" ]]; then
    checkoutGitRepository dm-framework-core $HOME/debtmanager
    checkoutGitRepository dm-authentication-provider $HOME/debtmanager
    checkoutGitRepository dm-integration-epp-img $HOME/debtmanager
    checkoutGitRepository dm-dev-tools $HOME/debtmanager
fi

echo ">>> Code Checkout Completed!!!"

