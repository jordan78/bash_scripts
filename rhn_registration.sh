#!/bin/bash


subscription-manager unregister 
subscription-manager clean
subscription-manager refresh
yum clean all
yum remove -y katello-ca-consumer-rhn*


sed -i 's/rhnoldsatellite/newsatellite_hostname/' /etc/sysconfig/rhn/up2date
sed -i 's/rhnoldsatellite/newsatellite_hostname/' /etc/rhsm/rhsm.conf

curl --insecure --output /tmp/katello-ca-consumer-latest.noarch.rpm https://satellite.example.com/pub/katello-ca-consumer-latest.noarch.rpm
yum localinstall -y /tmp/katello-ca-consumer-latest.noarch.rpm 


subscription-manager register --org="ORG_Name" --activationkey="ActivationID"

if grep -q -i "release 6" /etc/redhat-release ; then 
  
     echo "$HOSTNAME is a RHEL 6"
     subscription-manager refresh 
     subscription-manager repos --enable=rhel-6-server-satellite-tools-6.4-rpms
     subscription-manager repos --disable=rhel-6-server-rh-common-rpms


elif grep -q -i "release 7" /etc/redhat-release ; then 
  
     echo "$HOSTNAME is a RHEL 7"
     subscription-manager repos --enable=rhel-7-server-satellite-tools-6.4-rpms
     subscription-manager repos --disable=rhel-7-server-rh-common-rpms


else 
     echo "$HOSTNAME is not a supported RHEL"
fi


yum install -y katello-agent

rm -rf /var/cache/yum/*
yum clean all
