#!/bin/bash

REQUIRED_PKG="sudo"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
  echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
   apt-get --yes install $REQUIRED_PKG
fi

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   echo " do a sudo su"
   exit 1
fi

sudo apt update 

REQUIRED_PKG="curl"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
  echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
   sudo apt-get --yes install $REQUIRED_PKG
   fi


REQUIRED_PKG="wget"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
  echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
   sudo apt-get --yes install $REQUIRED_PKG
   fi

wget -O splunk-9.0.2-17e00c557dc1-Linux-x86_64.tgz "https://download.splunk.com/products/splunk/releases/9.0.2/linux/splunk-9.0.2-17e00c557dc1-Linux-x86_64.tgz"
#wget -O splunk-9.0.1-82c987350fde-Linux-x86_64.tgz "https://download.splunk.com/products/splunk/releases/9.0.1/linux/splunk-9.0.1-82c987350fde-Linux-x86_64.tgz"

tar -xvzf splunk*.tgz -C /opt

useradd -m splunk

export SPLUNK_HOME="/opt/splunk"

mkdir $SPLUNK_HOME

chown -R splunk:splunk $SPLUNK_HOM

chown -R splunk:splunk /opt/splunk

sudo /opt/splunk/bin/splunk start --accept-license

/opt/splunk/bin/splunk stop

/opt/splunk/bin/splunk enable boot-start

sudo /opt/splunk/bin/splunk start

echo "splunk has been installed successfully"

sleep 15

exit
