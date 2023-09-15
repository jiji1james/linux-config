#!/usr/bin/env bash
cwd=$(pwd)

# Install AWS CLI
echo ""
echo ">>>> Installing AWS CLI Version 2"
cd $HOME
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf $HOME/aws
rm -f awscliv2.zip

TOOLS_HOME="$HOME/tools"
JAVA_INSTALL_HOME="$HOME/java"

mkdir -p $JAVA_INSTALL_HOME
cd $JAVA_INSTALL_HOME

JAVA_8_FULL_VERSION='8.372.07.1'
JAVA_11_FULL_VERSION='11.0.19.7.1'
JAVA_17_FULL_VERSION='17.0.7.7.1'

function installCorrettoJava {
    JAVA_FULL_VERSION=$1
    JAVA_VERSION=$2

    if [[ -z $JAVA_FULL_VERSION ]]
    then
        JAVA_FULL_VERSION=$JAVA_8_FULL_VERSION
    fi

    if [[ -z $JAVA_VERSION ]]
    then
        JAVA_VERSION="8"
    fi

    if [ ! -d "$JAVA_INSTALL_HOME/jdk$JAVA_VERSION" ]
    then
        JAVA_URL="https://corretto.aws/downloads/resources/$JAVA_FULL_VERSION/amazon-corretto-$JAVA_FULL_VERSION-linux-x64.tar.gz"
        echo ">>> Install Corretto - $JAVA_FULL_VERSION from $JAVA_URL"

        wget $JAVA_URL
        tar -xvf amazon-corretto-$JAVA_FULL_VERSION-linux-x64.tar.gz
        mv amazon-corretto-$JAVA_FULL_VERSION-linux-x64 jdk$JAVA_VERSION
        rm -rf amazon-corretto-$JAVA_FULL_VERSION-linux-x64.tar.gz
    else
        echo ">>> Corretto $JAVA_FULL_VERSION already exists"
    fi
}

echo ""
echo ">>>> Installing Java"
installCorrettoJava $JAVA_8_FULL_VERSION 8
installCorrettoJava $JAVA_11_FULL_VERSION 11
installCorrettoJava $JAVA_17_FULL_VERSION 17

mkdir -p $TOOLS_HOME
cd $TOOLS_HOME

echo ""
echo ">>>> Installing Maven"
MVN_VERSION='3.9.4'
if [ ! -d "apache-maven-$MVN_VERSION" ]
then
    MAVEN_URL="https://dlcdn.apache.org/maven/maven-3/$MVN_VERSION/binaries/apache-maven-$MVN_VERSION-bin.tar.gz"
    echo ">>> Install Apache Maven - $MVN_VERSION from $MAVEN_URL"

    curl -k $MAVEN_URL --output apache-maven-$MVN_VERSION-bin.tar.gz
    tar -xvf apache-maven-$MVN_VERSION-bin.tar.gz
    rm -f apache-maven-$MVN_VERSION-bin.tar.gz
else
    echo ">>> Apache Maven $MVN_VERSION already exists"
fi

echo ""
echo ">>>> Installing ant"
ANT_VERSION='1.9.16'
if [ ! -d "apache-ant-$ANT_VERSION" ]
then
    ANT_URL="https://dlcdn.apache.org/ant/binaries/apache-ant-$ANT_VERSION-bin.tar.gz"
    echo ">>> Install Apache Ant - $ANT_VERSION from $ANT_URL"

    curl -k $ANT_URL --output apache-ant-$ANT_VERSION-bin.tar.gz
    tar -xvf apache-ant-$ANT_VERSION-bin.tar.gz
    rm -f apache-ant-$ANT_VERSION-bin.tar.gz
else
    echo ">>> Apache Ant $ANT_VERSION already exists"
fi

cd $cwd

