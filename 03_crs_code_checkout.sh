#!/usr/bin/env bash

# Function to checkout/update git repository
function checkoutGitRepository {
  repoName=$1
  parentPath=$2

  checkoutPath="$parentPath/$repoName"

  echo ">>>  Git Repo: $repoName Checkout Path: $checkoutPath"

  if [[ -d $checkoutPath ]]; then
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

echo "------------------------------------------------------------"
read -p "Checkout Callout Services (Y/N): " coscheckout
read -p "Checkout Communicator (Y/N): " commcheckout
read -p "Checkout Batch Process Orchestator (Y/N): " bpocheckout
read -p "Checkout Debt Manager for Cloud (Y/N): " cloudcheckout
read -p "Checkout Debt Manager for 13 (Y/N): " dm13checkout
read -p "Checkout Debt Manager for 12 (Y/N): " dm12checkout
read -p "Checkout Debt Manager Libraries (Y/N): " libcheckout
read -p "Checkout Debt Manager Tenant Admin (Y/N): " tacheckout
echo "------------------------------------------------------------"

echo ""
if [[ "$coscheckout" == "Y" || "$coscheckout" == "y" ]]; then
  echo ">>> Checkout Callout Services Code"
  mkdir -p $HOME/crs-apps/cos
  checkoutGitRepository callout-service $HOME/crs-apps/cos
fi

echo ""
if [[ "$commcheckout" == "Y" || "$commcheckout" == "y" ]]; then
  echo ">>> Checkout Communicator Code"
  mkdir -p $HOME/crs-apps/comm
  checkoutGitRepository cnr-comm-service $HOME/crs-apps/comm
  checkoutGitRepository cnr-comm-ui $HOME/crs-apps/comm
fi

echo ""
if [[ "$bpocheckout" == "Y" || "$bpocheckout" == "y" ]]; then
  echo ">>> Checkout Batch Process Orchestrator Code"
  mkdir -p $HOME/debtmanager/bpo
  checkoutGitRepository bpo-services $HOME/debtmanager/bpo
  checkoutGitRepository bpo-ui $HOME/debtmanager/bpo
fi

echo ""
if [[ "$cloudcheckout" == "Y" || "$cloudcheckout" == "y" ]]; then
  echo ">>> Checkout Debt Manager Cloud Code"
  mkdir -p $HOME/debtmanager/cloud/code
  checkoutGitRepository crsj2ee $HOME/debtmanager/cloud/code
  checkoutGitRepository browser-client $HOME/debtmanager/cloud/code
  checkoutGitRepository db-postgres $HOME/debtmanager/cloud/code
  checkoutGitRepository environment $HOME/debtmanager/cloud/code
  checkoutGitRepository etl $HOME/debtmanager/cloud/code
  checkoutGitRepository reports $HOME/debtmanager/cloud/code
  checkoutGitRepository configuration-management $HOME/debtmanager/cloud/code

  checkoutGitRepository dm-tomcat $HOME/debtmanager/cloud
  checkoutGitRepository dm-activemq-artemis $HOME/debtmanager/cloud
fi

echo ""
if [[ "$dm13checkout" == "Y" || "$dm13checkout" == "y" ]]; then
  echo ">>> Checkout Debt Manager OnPrem 13 Code"
  mkdir -p $HOME/debtmanager/onprem/13/code
  checkoutGitRepository crsj2ee $HOME/debtmanager/onprem/13/code
  checkoutGitRepository browser-client $HOME/debtmanager/onprem/13/code
  checkoutGitRepository environment $HOME/debtmanager/onprem/13/code
  checkoutGitRepository configuration-management $HOME/debtmanager/onprem/13/code
  checkoutGitRepository db-sqlserver $HOME/debtmanager/onprem/13/code

  checkoutGitRepository dm-jboss $HOME/debtmanager/onprem/13
fi

echo ""
if [[ "$dm12checkout" == "Y" || "$dm12checkout" == "y" ]]; then
  echo ">>> Checkout Debt Manager OnPrem 12 Code"
  mkdir -p $HOME/debtmanager/onprem/12/code
  checkoutGitRepository crsj2ee $HOME/debtmanager/onprem/12/code
  checkoutGitRepository browser-client $HOME/debtmanager/onprem/12/code
  checkoutGitRepository environment $HOME/debtmanager/onprem/12/code
  checkoutGitRepository configuration-management $HOME/debtmanager/onprem/12/code
  checkoutGitRepository db-sqlserver $HOME/debtmanager/onprem/12/code

  checkoutGitRepository dm-jboss $HOME/debtmanager/onprem/12
fi

echo ""
if [[ "$libcheckout" == "Y" || "$libcheckout" == "y" ]]; then
  echo ">>> Checkout Debt Manager Libraries"
  mkdir -p $HOME/debtmanager/library
  checkoutGitRepository dm-framework-core $HOME/debtmanager/library
  checkoutGitRepository dm-authentication-provider $HOME/debtmanager/library
  checkoutGitRepository dm-integration-epp-img $HOME/debtmanager/library
  checkoutGitRepository dm-dev-tools $HOME/debtmanager/library
fi

echo ""
if [[ "$tacheckout" == "Y" || "$tacheckout" == "y" ]]; then
  mkdir -p $HOME/debtmanager/ta
  echo ">>> Checkout Debt Manager Tenant Admin"
  checkoutGitRepository dm-tenant-admin-service $HOME/debtmanager/ta
  checkoutGitRepository dm-tenant-admin-ui $HOME/debtmanager/ta
fi

echo ">>> Code Checkout Completed!!!"
