#!/usr/bin/env zsh

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

# Set Java Home
function setJavaHome {
	version=$1
	if [[ -z version ]]
	then
		version = "8"
	fi

	export JAVA_HOME="$HOME/java/jdk$version"

	echo ">>> Java Home set as $JAVA_HOME"
	export PATH="$JAVA_HOME/bin:$OLD_PATH"
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
	contianerName="dm-postgres-$containerVersion"
	
	echo ">>> Deleting running contianer: $contianerName"
	docker rm -f $contianerName

	echo ">>> Running Postgres Container: 828586629811.dkr.ecr.us-east-1.amazonaws.com/dm-postgres:$containerVersion"
	docker run -d --name $contianerName -p 5432:5432 828586629811.dkr.ecr.us-east-1.amazonaws.com/dm-postgres:$containerVersion
}

# Apache ArtemisMQ Docker
function runArtemis {
	containerVersion=$1
	if [[ -z $containerVersion ]]
	then
		containerVersion='2023.9.0'
	fi
	contianerName="dm-mq-$containerVersion"
	
	echo ">>> Deleting running contianer: $contianerName"
	docker rm -f $contianerName

	echo ">>> Running Artemis Container: 828586629811.dkr.ecr.us-east-1.amazonaws.com/dm-activemq-artemis:$containerVersion"
	docker run -d --name $contianerName -p 5432:5432 828586629811.dkr.ecr.us-east-1.amazonaws.com/dm-postgres:$containerVersion
}

# Apache Httpd Docker
function runHttpd {
    containerVersion=$1
    if [[ -z $containerVersion ]]
    then
        containerVersion='develop'
    fi
    containerName="dm-httpd-$containerVersion"

    echo ">>> Deleting running container: $containerName"
    docker rm -f $containerName

    echo ">>> Running httpd Container: 828586629811.dkr.ecr.us-east-1.amazonaws.com/dm-httpd:$containerVersion"
	docker run -d --name $containerName -p 8080:80 828586629811.dkr.ecr.us-east-1.amazonaws.com/dm-httpd:$containerVersion
}

function listEcrImages {
	repo_name=$1
	search_text=$2
	if [[ -z $repo_name || -z $search_text ]]
	then
		echo "Usage: listImages <repo_name> <search_text>"
		echo "eg: listImages dm-rest-services R11.3"
		return
	fi
	command="aws ecr describe-images --repository-name $repo_name --query 'reverse(sort_by(imageDetails,& imagePushedAt))[*]' | jq '.[:10] | .[] | select (.imageTags | .[] | contains(\"$search_text\")) | {repositoryName:.repositoryName, imageTags:.imageTags, imagePushedAt:.imagePushedAt, lastRecordedPullTime:.lastRecordedPullTime}'"
	echo ">>> $command"
	eval "$command"
}