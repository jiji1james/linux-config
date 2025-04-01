#!/usr/bin/env zsh

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# Place private bin directories in the path
if [ -e ${HOME}/bin ]; then
	export PATH=${HOME}/bin:${PATH}
fi

# Figure out the machine
unameMachine="$(uname -s)"
case "${unameMachine}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameMachine}"
esac

# Figure out the arch
unameArch="$(uname -m)"

# Get color code
function getColorCode {
	# Default color is white if none provided
	local color=${1:-"white"}
	
	# Define color codes
	local colorCode=""
	case "$color" in
		"black")   colorCode="\033[30m" ;;
		"red")     colorCode="\033[31m" ;;
		"green")   colorCode="\033[32m" ;;
		"yellow")  colorCode="\033[33m" ;;
		"blue")    colorCode="\033[34m" ;;
		"magenta") colorCode="\033[35m" ;;
		"cyan")    colorCode="\033[36m" ;;
		"white")   colorCode="\033[37m" ;;
		*)         colorCode="\033[37m" ;; # Default to white
	esac
	
	echo "$colorCode"
}

# Echo a message in a specified color
function echoColor {
	# Default message is empty if none provided
	local message=${1:-""}
	
	# Default color is white if none provided
	local color=${2:-"white"}
	
	# Get color code
	local colorCode=$(getColorCode "$color")
	
	# Reset color code
	local resetCode="\033[0m"
	
	# Print the message with color
	echo -e "${colorCode}${message}${resetCode}"
}

# Print a line of characters that fills the width of the console
function printLine {
	# Default character is "-" if none provided
	local char=${1:-"-"}
	
	# Default color is white if none provided
	local color=${2:-"white"}
	
	# Get color code
	local colorCode=$(getColorCode "$color")
	
	# Reset color code
	local resetCode="\033[0m"
	
	# Get the width of the terminal
	local width=$(tput cols)
	
	# Create a string of the character that fills the width
	local line=""
	for ((i=0; i<width; i++)); do
		line="${line}${char}"
	done
	
	# Print the line with color
	echo -e "${colorCode}${line}${resetCode}"
}

# Print a centered string with filler characters on both sides
function printCentered {
	# Default string is empty if none provided
	local text=${1:-""}
	
	# Default character is "-" if none provided
	local char=${2:-"-"}
	
	# Default color is white if none provided
	local color=${3:-"white"}
	
	# Get color code
	local colorCode=$(getColorCode "$color")
	
	# Reset color code
	local resetCode="\033[0m"
	
	# Get the width of the terminal
	local width=$(tput cols)
	
	# Calculate padding needed on each side
	local textLength=${#text}
	local totalPadding=$((width - textLength))
	local leftPadding=$((totalPadding / 2))
	local rightPadding=$((totalPadding - leftPadding))
	
	# Create the left and right padding strings
	local leftPad=""
	local rightPad=""
	
	for ((i=0; i<leftPadding; i++)); do
		leftPad="${leftPad}${char}"
	done
	
	for ((i=0; i<rightPadding; i++)); do
		rightPad="${rightPad}${char}"
	done
	
	# Print the centered text with padding and color
	echo -e "${colorCode}${leftPad}${text}${rightPad}${resetCode}"
}


# Print Status Block
function printEnvironmentStatus {
	echo "---------------------------------------"
	echo "Machine:        $unameMachine"
	echo "Arch:           $unameArch"
	echo "SHELL:          $(which $SHELL)"
	echo "---------------------------------------"
	echo "Start Up:       $(uptime -s)"
	echo "Nameserver:     $HOST_IP"
	echo "WSL IP:         $WSL_IP"
	echo "Date:           $(date)"
	echo "---------------------------------------"
}

# Declare variables
export DM_HOME="$HOME/debtmanager"
export TOMCAT_HOME="$DM_HOME/dm-tomcat/apache-tomcat"
export JBOSS_HOME="$DM_HOME/dm-jboss/jboss-eap"
export FS_HOME="$DM_HOME/fs"

# Execute Git Command Recursively in sub folders
function rgit {
	echo ""
	printLine "#" "magenta"
	printCentered "Executing git command: $*" "-" "green"
	printLine "#" "magenta"

	dirs -c             # Clear the pushd stack
	for dir in ./*/     # list directories in the form "/tmp/dirname/"
	do
		dir=${dir%*/}
		echo ""
		printCentered ">>>> Working on: ${dir} <<<<" "-" "cyan"
		echo ""	
		if [ -d "${dir}/.git" ]
		then
			pushd $dir
			git $*
			popd
		else
			echoColor "Skipping $dir" "yellow"
		fi
	done
}

# Delete all Git Branches except master and develop
function gitCleanBranches {
    echo "Branches to delete:"
    git branch | grep -v master
	git branch | grep -v master | xargs git branch -D
}

# Execute Git Clean Branches Recursively in sub folders
function gitCleanBranchesRecurse {
    dirs -c				# Clear the pushd stack
	for dir in ./*/     # list directories in the form "/tmp/dirname/"
	do
		dir=${dir%*/}
		echo ""
		printCentered ">>>> Working on: ${dir} <<<<" "-" "cyan"
		echo ""
		if [ -d "${dir}/.git" ]
		then
			pushd $dir
			gitCleanBranches  # Call the existing gitCleanBranches function
			popd
		else
			echo "Skipping $dir"
		fi
	done
}

# Invoke gradle wrapper
function gw {
	commad=""
	if [ -f "./gradlew" ]; then
		command="./gradlew $@"
	elif [ -f "../gradlew" ]; then
		command="../gradlew $@"
	else
		echo "Gradle Wrapper not found"
	fi
	echo ">>> Running: $command"
	eval $command
}

# Invoke gradle wrapper without cache
function gwNoCache {
	commad=""
	if [ -f "./gradlew" ]; then
		command="./gradlew $@"
	elif [ -f "../gradlew" ]; then
		command="../gradlew $@"
	else
		echo "Gradle Wrapper not found"
	fi
	echo ">>> Running: $command"
	eval $command --no-build-cache
}

# Set Java Home
function setJavaHome {
	# version=$1
	# if [[ -z $version ]]
	# then
	# 	version = "8"
	# fi

	# export JAVA_HOME="$HOME/java/jdk$version"

	# echo ">>> Java Home set as $JAVA_HOME"
	# export PATH="$JAVA_HOME/bin:$OLD_PATH"
	echo ">>> sdk use java <version>"
}

function print_usage_jdk() {
    VERSIONS=$(\ls $SDKMAN_DIR/candidates/java | \grep -v current | \awk -F'.' '{print $1}' | \sort -nr | \uniq)
    CURRENT=$(\basename $(\readlink $JAVA_HOME || \echo $JAVA_HOME) | \awk -F'.' '{print $1}')
    \echo "Available versions: "
    \echo "$VERSIONS"
    \echo "Current: $CURRENT"
    \echo "Usage: jdk <java_version>"
}

function jdk() {
  if [[ $# -eq 1 ]]; then
    VERSION_NUMBER=$1
    IDENTIFIER=$(\ls $SDKMAN_DIR/candidates/java | \grep -v current | \grep "^$VERSION_NUMBER." | \sort -r | \head -n 1)
    sdk use java $IDENTIFIER
  else
    print_usage_jdk
  fi
}

# Set Debt Manager Environment
function setDmEnvironment {
	version=$1
	if [[ -z $version ]]
	then
		version="cloud"
	fi

	export DM_VERSION=$version
	if [[ $version == "cloud" ]]; then
		export DM_HOME=$HOME/debtmanager/$version
	else
		export DM_HOME=$HOME/debtmanager/onprem/$DM_VERSION
	fi

	# Set Java Home
	jdk 8
}

# Set Container Runtime
function setContainerRuntime {
	runtime=$1
	if [[ -z $runtime ]]
	then
		runtime="podman"
	fi

	export CONTAINER_RUNTIME=$runtime

	echo ">>> Container runtime set as $CONTAINER_RUNTIME"
}

# Login to ECR
function ecrLogin {
	command="aws ecr get-login-password --region us-east-1 | $CONTAINER_RUNTIME  login --username AWS --password-stdin 828586629811.dkr.ecr.us-east-1.amazonaws.com"

	echo ">>> Attempting ECR login using command $command"
	eval $command
}

# Recursive dos2unix
function dos2unix-recurse {
	find . -type f -name "*.txt" | xargs dos2unix
}

# Kill process by keyword
function killProcess {
    keyword=$1
    if [[ -z $keyword ]]; then
        echo "Usage: killProcess <keyword>"
        return 1
    fi

    pids=$(pgrep -f $keyword)
    if [[ -z $pids ]]; then
        echo "No process found with keyword '$keyword'."
        return 1
    fi

    echo "Killing processes with keyword '$keyword': $pids"
    kill -9 $pids
}

# Clean Tomcat
function cleanTomcat {
    rm -rf $TOMCAT_HOME/bin/ObjectStore
    rm -f $TOMCAT_HOME/bin/Blaze.log
    rm -rf $TOMCAT_HOME/dmIgniteCache
    rm -rf $TOMCAT_HOME/logs
    rm -rf $TOMCAT_HOME/temp
    rm -rf $TOMCAT_HOME/work
}

# Start Tomcat
function startTomcat {
	current_path=$(pwd)
	echo ">>> Cleaning Tomcat"
	cleanTomcat
	echo ">>> Replace log4j files"
	rsync -av --ignore-existing $FS_HOME/log4j/*.xml $TOMCAT_HOME/log4j/
	echo ">>> Starting Tomcat"
	cd $TOMCAT_HOME/bin
	./dm-startup.sh
	cd $current_path
}

# Stop Tomcat
function stopTomcat {
	killProcess "tomcat"
}

# Recursive dos2unix
function dos2unixRecurse {
	find . -type f -exec dos2unix {} +
}

# Sql Server Docker
function runSqlServer {
	containerVersion=$1
	if [[ -z $containerVersion ]]
	then
		containerVersion='develop'
	fi
	contianerName="dm-sqlserver-$containerVersion"

	echo ">>> Deleting running container: $contianerName"
	docker rm -f $contianerName

	echo ">>> Running SqlServer Container: 828586629811.dkr.ecr.us-east-1.amazonaws.com/dm-sqlserver:$containerVersion"
	docker run -d --name $contianerName --platform linux/amd64 -p 1433:1433 828586629811.dkr.ecr.us-east-1.amazonaws.com/dm-sqlserver:$containerVersion
}

# Postgres Docker
function runPostgresServer {
	containerVersion=$1
	if [[ -z $containerVersion ]]
	then
		containerVersion='develop'
	fi
	contianerName="dm-pg-$containerVersion"

	echo ">>> Deleting running container: $contianerName"
	docker rm -f $contianerName

	echo ">>> Running Postgres Container: 828586629811.dkr.ecr.us-east-1.amazonaws.com/dm-postgres:$containerVersion"
	docker run -d --name $contianerName -p 5432:5432 828586629811.dkr.ecr.us-east-1.amazonaws.com/dm-postgres:$containerVersion
}

# Apache ArtemisMQ Docker
function runArtemis {
	containerVersion=$1
	if [[ -z $containerVersion ]]
	then
		containerVersion='2023.9.1'
	fi
	contianerName="dm-mq-$containerVersion"
	
	echo ">>> Deleting running container: $contianerName"
	docker rm -f $contianerName

	echo ">>> Running Artemis Container: 828586629811.dkr.ecr.us-east-1.amazonaws.com/dm-activemq-artemis:$containerVersion"
	docker run -d --name $contianerName -p 8161:8161 -p 61616:61616 828586629811.dkr.ecr.us-east-1.amazonaws.com/dm-activemq-artemis:$containerVersion
}

# FitLogic Primary Container - Cloud Version
function runCloudFitLogic {
	containerVersion=$1
	if [[ -z $containerVersion ]]
	then
		containerVersion='washington.0.0-ubuntu'
	fi
	contianerName="fl-cloud"
	
	echo ">>> Deleting running container: $contianerName"
	docker rm -f $contianerName

	echo ">>> Running Fit Logic Container: 828586629811.dkr.ecr.us-east-1.amazonaws.com/dm-smarts:$containerVersion"
	docker run -d --name $contianerName \
		-p 443:8443 \
		--env-file $DM_HOME/fs/tenant1/dmfs/fitlogic/smarts.env.settings \
		828586629811.dkr.ecr.us-east-1.amazonaws.com/dm-smarts:$containerVersion
}

# FitLogic Primary Container - OnPrem Version
function runOnPremFitLogicPrimary {
	containerVersion=$1
	if [[ -z $containerVersion ]]
	then
		containerVersion='washington.0.0-ubuntu'
	fi
	contianerName="fl-onprem-primary"
	
	echo ">>> Deleting running container: $contianerName"
	docker rm -f $contianerName

	echo ">>> Running Fit Logic Container: 828586629811.dkr.ecr.us-east-1.amazonaws.com/dm-smarts:$containerVersion"
	docker run -d --name $contianerName \
		-p 443:8443 \
		--env-file $DM_HOME/fs/dflttnt/dmfs/fitlogic/smarts.env.settings \
		828586629811.dkr.ecr.us-east-1.amazonaws.com/dm-smarts:$containerVersion
}

function loadFitLogicInitalRepo {
  if [ "$DM_VERSION" = "cloud" ]; then
      containerName="fl-cloud"
      downloadUrl="http://nexus.infra.crsdev.com:8081/repository/dm-releases/com/crs/dm/fitlogic/Fitlogic-Init/1.0.0.0/Fitlogic-Init-1.0.0.0.zip"
  else
      containerName="fl-onprem-primary"
      downloadUrl="http://nexus.infra.crsdev.com:8081/repository/dm-releases/com/crs/dm/fitlogic/Fitlogic-InitialRepo-OnPrem/1.0.0/Fitlogic-InitialRepo-OnPrem-1.0.0.zip"
  fi

  echo ">>> Download Initial Repo"
  wget -nv $downloadUrl -P $HOME

  sleep 20

  echo ">>> Import Inital Repo"
  filename=$(basename $downloadUrl)
  docker cp $HOME/$filename $containerName:/opt/sl/$filename
  docker exec $containerName sladmin repository --import /opt/sl/$filename
  rm -f $HOME/$filename
}

# FitLogic File Container - OnPrem Version
function runOnPremFitLogicFileContainer {
	containerVersion=$1
	if [[ -z $containerVersion ]]
	then
		containerVersion='washington.0.0-alpine'
	fi
	contianerName="fl-onprem-file-instance1"
	
	echo ">>> Deleting running container: $contianerName"
	docker rm -f $contianerName

	echo ">>> Running Fit Logic Container: 828586629811.dkr.ecr.us-east-1.amazonaws.com/dm-smarts:$containerVersion"
	docker run -d --name $contianerName \
		-p 8081:8080 \
		--env sl_enabledeploymentmonitor="true" \
		-v $DM_HOME/fs/dflttnt/dmfs/fitlogic/smartd/container1:/app/data \
		828586629811.dkr.ecr.us-east-1.amazonaws.com/dm-smarts:$containerVersion
}

# DM Rest Docker
function runDmRest {
	containerVersion=$1
	if [[ -z $containerVersion ]]
	then
		containerVersion='develop'
	fi
	contianerName="dm-rest-$containerVersion"

	echo ">>> Deleting running container: $contianerName"
	docker rm -f $contianerName

	echo ">>> Running dm-rest-services Container: 828586629811.dkr.ecr.us-east-1.amazonaws.com/dm-rest-services:$containerVersion"
	docker run --name $contianerName \
		-p 8080:8080 \
		-e dbhost=host.docker.internal -e dbport=5432 \
		-e mqhost=host.docker.internal -e mqport=61616 \
		-e tadb=dm_tenant_admin -e tadbuser=tenantadmin -e tadbpassword=P@55w0rd \
		-e nodename=dm -e debug=false \
		-v $HOME/debtmanager/fs:/usr/local/dm \
		828586629811.dkr.ecr.us-east-1.amazonaws.com/dm-rest-services:$containerVersion
}

function listEcrImages {
	repo_name=$1
	search_text=$2
	if [[ -z $repo_name || -z $search_text ]]
	then
		echo "Usage: listEcrImages <repo_name> <search_text>"
		echo "eg: listEcrImages dm-rest-services R11.3"
		return
	fi
	command="aws ecr describe-images --repository-name $repo_name --query 'reverse(sort_by(imageDetails,& imagePushedAt))[*]' | jq '.[:10] | .[] | select (.imageTags | .[] | contains(\"$search_text\")) | {repositoryName:.repositoryName, imageTags:.imageTags, imagePushedAt:.imagePushedAt, lastRecordedPullTime:.lastRecordedPullTime}'"
	echo ">>> $command"
	eval "$command"
}

# Function to add wayland to Intellij startup options
function addWaylandToIntellij {
    # Check if path argument is provided
    if [ -z "$1" ]; then
        echo "Usage: addWaylandToIntellij <path_to_idea64.vmoptions>"
        echo "Example: addWaylandToIntellij ~/.config/JetBrains/IdeaIC2023.3/idea64.vmoptions"
        return 1
    fi

    # Store path argument
    vmoptions_file="$1"

    # Check if file exists
    if [ ! -f "$vmoptions_file" ]; then
        echo "Error: File not found - $vmoptions_file"
        return 1
    fi

    echo "Found vmoptions file at: $vmoptions_file"

    # Check if WLToolkit option already exists
    if ! grep -q "^-Dawt.toolkit.name=WLToolkit" "$vmoptions_file"; then
        echo "Adding Wayland toolkit option..."
        echo "-Dawt.toolkit.name=WLToolkit" >> "$vmoptions_file"
    else
        echo "Wayland toolkit option already exists"
    fi

    echo "Current contents of $vmoptions_file:"
    cat "$vmoptions_file"
}
