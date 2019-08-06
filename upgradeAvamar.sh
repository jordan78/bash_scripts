#!/bin/bash


curl --insecure --output /tmp/ddrman47_linux_x86_64.tar https://myweb.domain.com/pub/ddrman47_linux_x86_64.tar

mkdir -p /u01/home/work/ddboost
mkdir -p /u01/home/opt/dpsappt/rmanagent
cp -u /tmp/ddrman47_linux_x86_64.tar /u01/home/work/ddboost
chmod -R 755 /u01/home/work/ddboost
chown -R oracle /u01/home/work/ddboost /u01/home/opt/


if [ -d "/u01/home/work/avamar" ]; then 

	runuser -l oracle -c 'cd /u01/home/work/avamar; echo y | ./uninstall.sh'
fi


runuser -l oracle -c 'tar -xf /u01/home/work/ddboost/ddrman47_linux_x86_64.tar -C /u01/home/work/ddboost/'
runuser -l oracle -c 'cd /u01/home/work/ddboost; echo y | ./install.sh'
runuser -l oracle -c "echo 'setenv RMAN_AGENT_HOME /u01/home/opt/dpsapps/rmanagent' >> /u01/home/bin/osetenv"

runuser -l oracle -c "rman target / <<EOF  
RUN {
ALLOCATE CHANNEL C1 TYPE SBT_TAPE PARMS 'SBT_LIBRARY=libddobk.so';
send 'set username xxxx password xxxx servername $hostname';
RELEASE CHANNEL C1;
}
EOF"

echo "Deleteing ddrman47 tar file from tmp directory"

rm -rf /tmp/ddrman47_linux_x86_64.tar

exit 0


