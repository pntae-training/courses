#!/bin/bash
#
# kc-XXX        Knowledge Checkpoint break script for XXXX
#
# description: This utility will make local system changes  \
#              that reproduce XXXX issues.  The broken system \
#              can then be used by GSS support engineers and \
#              Red Hat support partners along with self-paced \
#              training modules to grow XXXX troubleshooting knowledge.
#
# processname: kc-XXXX
#
#
# Last Modified:
#       xxxxxxx <xxxx@redhat.com> xx/xx/2014
#
# Usage: ./kc-XXXX <KCID>
# <KCID> can be one of the following:
# break1 - used to reproduce a system that has issue XXXX
# grade1 - used to grade a system after resolving the XXXX issue
#
# Error exit codes:
# 0: exited successfully
# 1: wrong hostname
# 2: syntax command usage
# 3: need to run as root user

bold=`tput bold`
normal=`tput sgr0`
black=`tput setaf 0`
red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
blue=`tput setaf 4`
magenta=`tput setaf 5`
cyan=`tput setaf 6`
white=`tput setaf 7`


MYHOSTNAME=`hostname`
MYNAME=`whoami`

if [[ ! $MYNAME == "root" ]]
then
        echo "$0 needs to be run by the root user."
        exit 3
fi

# startup
logger -p local0.notice "Initiating $0 with option $@"
echo "Initiating $0 with option $@"


lab1-grade() {

        STATUS="failed"
        echo "Grading.  Please wait."


        # insert your grade code here and set STATUS="success" if the lesson criteria is met.
        yum install nc -y &> /dev/null
        nc -z server.example.com 8000
        var1=$?
        if [[ $var1 == "0" ]]
        then
                STATUS="success"
        fi

        # end your grading code here

        if [[ $STATUS == "success" ]]
        then
                echo "Success."
                echo "${bold}COMPLETION CODE: SPLUNK7RHEL7${normal}"
        else
                echo "Sorry.  There still seems to be a problem"
        fi

}

lab2-grade() {
        STATUS="failed"
        echo "Grading.  Please wait."


        # insert your grade code here and set STATUS="success" if the lesson criteria is met.
        container_name=$(ssh cloud-user@server.example.com "sudo podman ps | grep 'Up' | head -1 | cut -f 1 -d ' '")
        ssh cloud-user@server.example.com "sudo podman exec $container_name sudo grep -ri 'AWX Connection Test Message' /opt/splunk/ &> /dev/null"
        var1=$?
        if [[ $var1 == "0" ]]
        then
                STATUS="success"
        fi

        # end your grading code here

        if [[ $STATUS == "success" ]]
        then
                echo "Success."
                echo "${bold}COMPLETION CODE: ANSIBLERHEL7SPLUNK${normal}"
        else
                echo "Sorry.  There still seems to be a problem"
        fi

}

lab3-grade() {
        STATUS="failed"
        echo "Grading.  Please wait."


        # insert your grade code here and set STATUS="success" if the lesson criteria is met.
        yum install nc -y &> /dev/null
        nc -z server.example.com 5601
        var1=$?
        if [[ $var1 == "0" ]]
        then
                STATUS="success"
        fi

        # end your grading code here

        if [[ $STATUS == "success" ]]
        then
                echo "Success."
                echo "${bold}COMPLETION CODE: ELKRHEL7ANSTACK${normal}"
        else
                echo "Sorry.  There still seems to be a problem"
        fi
}

lab4-grade() {
        STATUS="failed"
        echo "Grading.  Please wait."


        # insert your grade code here and set STATUS="success" if the lesson criteria is met.
        ssh cloud-user@server.example.com 'sudo grep -ri "AWX Connection Test Message" /var/log/logstash/logstash-plain.log &> /dev/null'
        var1=$?
        if [[ $var1 == "0" ]]
        then
                STATUS="success"
        fi

        # end your grading code here

        if [[ $STATUS == "success" ]]
        then
                echo "Success."
                echo "${bold}COMPLETION CODE: ANSIBLERHEL7STACKELASTIC${normal}"
        else
                echo "Sorry.  There still seems to be a problem"
        fi
}

case "$1" in

        lab1-grade)
                lab1-grade
                ;;
        lab2-grade)
                lab2-grade
                ;;
        lab3-grade)
                lab3-grade
                ;;
        lab4-grade)
                lab4-grade
                ;;
        *)
                echo $"Usage: $0 {lab1-grade | lab2-grade | lab3-grade | lab4-grade}"
                exit 2
esac


# ending
logger -p local0.notice "Completed $0 with option $@ successfully"
echo "Completed $0 with option $@ successfully"
exit 0


