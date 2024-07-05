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

# Print Status Block
function printEnvironmentStatus {
	echo "---------------------------------------"
	echo "Machine:        $unameMachine"
	echo "Arch:           $unameArch"
	echo "SHELL:          $(which $SHELL)"
	echo "Container:      $CONTAINER_RUNTIME"
	echo "Java:           $JAVA_HOME"
	echo "---------------------------------------"
	echo "Start Up:       $(uptime -s)"
	echo "Nameserver:     $HOST_IP"
	echo "WSL IP:         $WSL_IP"
	echo "Date:           $(date)"
	echo "---------------------------------------"
}

# Delete all Git Branches except master and develop
function gitCleanBranches {
    echo "Branches to delete:"
    git branch | grep -v master
	git branch | grep -v master | xargs git branch -D
}

# Execute Git Command Recursively in sub folders
function rgit {
	dirs -c				# Clear the pushd stack
	for dir in ./*/     # list directories in the form "/tmp/dirname/"
	do
		dir=${dir%*/}
		echo ""
		echo ">>>> Working on: ${dir} <<<<"
		echo ""	
		if [ -d "${dir}/.git" ]
		then
			pushd $dir
			git $*
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
	version=$1
	if [[ -z $version ]]
	then
		version = "8"
	fi

	export JAVA_HOME="$HOME/java/jdk$version"

	echo ">>> Java Home set as $JAVA_HOME"
	export PATH="$JAVA_HOME/bin:$OLD_PATH"
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

# Clean Tomcat
function cleanTomcat {
    rm -rf $HOME/debtmanager/dm-tomcat/apache-tomcat/bin/ObjectStore
    rm -f $HOME/debtmanager/dm-tomcat/apache-tomcat/bin/Blaze.log
    rm -rf $HOME/debtmanager/dm-tomcat/apache-tomcat/dmIgniteCache
    rm -rf $HOME/debtmanager/dm-tomcat/apache-tomcat/logs
    rm -rf $HOME/debtmanager/dm-tomcat/apache-tomcat/temp
    rm -rf $HOME/debtmanager/dm-tomcat/apache-tomcat/work
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


# Sql Server Docker
function runSqlServer {
	containerVersion=$1
	if [[ -z $containerVersion ]]
	then
		containerVersion='develop'
	fi
	contianerName="dm-sqlserver-$containerVersion"

	echo ">>> Deleting running contianer: $contianerName"
	command="$CONTAINER_RUNTIME rm -f $contianerName"
	eval $command

	echo ">>> Running SqlServer Container: 828586629811.dkr.ecr.us-east-1.amazonaws.com/dm-sqlserver:$containerVersion"
	command="$CONTAINER_RUNTIME run -d --name $contianerName --platform linux/amd64 -p 1433:1433 828586629811.dkr.ecr.us-east-1.amazonaws.com/dm-sqlserver:$containerVersion"
	eval $command
}

# Postgres Docker
function runPostgresServer {
	containerVersion=$1
	if [[ -z $containerVersion ]]
	then
		containerVersion='develop'
	fi
	contianerName="dm-postgres-$containerVersion"

	echo ">>> Deleting running contianer: $contianerName"
	command="$CONTAINER_RUNTIME rm -f $contianerName"
	eval $command

	echo ">>> Running Postgres Container: 828586629811.dkr.ecr.us-east-1.amazonaws.com/dm-postgres:$containerVersion"
	command="$CONTAINER_RUNTIME run -d --name $contianerName -p 5432:5432 828586629811.dkr.ecr.us-east-1.amazonaws.com/dm-postgres:$containerVersion"
	eval $command
}

# Apache ArtemisMQ Docker
function runArtemis {
	containerVersion=$1
	if [[ -z $containerVersion ]]
	then
		containerVersion='2023.9.1'
	fi
	contianerName="dm-mq-$containerVersion"
	
	echo ">>> Deleting running contianer: $contianerName"
	command="$CONTAINER_RUNTIME rm -f $contianerName"
	eval $command

	echo ">>> Running Artemis Container: 828586629811.dkr.ecr.us-east-1.amazonaws.com/dm-activemq-artemis:$containerVersion"
	command="$CONTAINER_RUNTIME run -d --name $contianerName -p 8161:8161 -p 61616:61616 828586629811.dkr.ecr.us-east-1.amazonaws.com/dm-activemq-artemis:$containerVersion"
	eval $command
}

# DM Rest Docker
function runDmRest {
	containerVersion=$1
	if [[ -z $containerVersion ]]
	then
		containerVersion='develop'
	fi
	contianerName="dm-rest-$containerVersion"

	echo ">>> Deleting running contianer: $contianerName"
	command="$CONTAINER_RUNTIME rm -f $contianerName"
	eval $command

	echo ">>> Running dm-rest-services Container: 828586629811.dkr.ecr.us-east-1.amazonaws.com/dm-rest-services:$containerVersion"
	command="$CONTAINER_RUNTIME run --name $contianerName \
	-p 8080:8080 \
	-e dbhost=host.docker.internal -e dbport=5432 \
	-e mqhost=host.docker.internal -e mqport=61616 \
	-e tadb=dm_tenant_admin -e tadbuser=tenantadmin -e tadbpassword=P@55w0rd \
	-e nodename=dm -e debug=false \
	-v $HOME/debtmanager/fs:/usr/local/dm \
	828586629811.dkr.ecr.us-east-1.amazonaws.com/dm-rest-services:$containerVersion"
	eval $command
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

# Short-hand for displaying configuration files without comments
function show {
	showFile=${1:?"${FUNCNAME[0]}: No file specified"}
	if [ ! -f "$showFile" ]; then
		echo "${FUNCNAME[0]}: No such file: $showFile" >&2
		return 2
	fi
	egrep -v '^\s*$|^\s*(#|//|;)' $showFile | perl -ne 'print unless /\/\*/../\*\//' | perl -ne 'print unless /<!--/../-->/'
}

# Function to intelligently un-tar files without having to memorize all the
# correct flags to tar.
function untar {
	local targetFile=${1:?"ERROR:  You must specify a file to untar!"}
	local fileExt=${targetFile##*.}
	local tarCommand=tar
	local evalCommand

	case $fileExt in
		tar)        # Uncompressed
			tarCommand="$tarCommand xvf"
			;;
		tgz|gz)     # GZip
			tarCommand="$tarCommand xvfz"
			;;
		bz2)        # BZip2
			tarCommand="$tarCommand xvfj"
			;;
		lgz|lz7|lz) # LZip
			tarCommand="$tarCommand xvfJ"
			;;
		*)          # Unknown
			echo "Unknown tar file extension: $fileExt" >&2
			return 1
	esac

	shift
	evalCommand="$tarCommand $targetFile $@"
	echo $evalCommand
	$evalCommand
}

# Function to intelligently zip resources without having to remember all the
# necessary flags.
function zip {
	local zipTarget=${1:?"ERROR:  You must specify a resource to zip!"}
	local zipFile=${zipTarget}.zip
	local zipOpts=$ZIP_OPTS
	local zipBin
	local zipCommand

	# Bail if zip has not been installed
	zipBin=$(which zip)
	if [ 0 -ne $? ]; then
		zipBin=/usr/bin/zip
		if [ ! -e $zipBin ]; then
			zipBin=/usr/local/bin/zip
			if [ ! -e $zipBin ]; then
				zipBin=/bin/zip
				if [ ! -e $zipBin ]; then
					echo "ERROR:  No zip binary in the path!" >&2
					return 1
				fi
			fi
		fi
	fi

	# Pass all arguments to the actual zip binary if the first argument to this
	# function is a flag.
	if [ "-" = "${zipTarget:0:1}" ]; then
		$zipBin $@
		return $?
	fi

	# Bail if there's nothing to do
	if [ ! -e "$zipTarget" ]; then
		echo "ERROR:  $zipTarget does not exist." >&2
		return 2
	fi

	# Update zip files that already exist
	if [ -e "$zipFile" ]; then
		zipOpts=${zipOpts}" --update"
	fi

	# Recursively zip directory targets
	if [ -d "$zipTarget" ]; then
		zipOpts=${zipOpts}" --recurse-paths"
	fi

	# Always verify the zip file and operate verbosely
	zipOpts=${zipOpts}" --test --verbose"

	# Perform the zip operation and return its exit state
	zipCommand="$zipBin $zipOpts $zipFile $zipTarget"
	echo $zipCommand
	$zipCommand
	return $?
}
