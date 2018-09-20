#!/bin/bash

work=`pwd`


header='#!/bin/bash\n
\n
function untar_payload()\n
{\n
    match=$(grep --text --line-number "^PAYLOAD:$" $0 | cut -d ":" -f 1)\n
    payload_start=$((match + 1))\n
    tail -n +$payload_start $0 | uudecode | tar -xvzf - -C / >> eds_install.log 2>&1\n
}\n

function clean_eds()\n
{\n
    rm -rf /usr/local/bin/{puppet.sh,k8s.sh,startup.sh,mq-agent,env.sh,cert-agent,kubelet}\n
    rm -rf /etc/kubernetes/\n
    rm -rf /etc/edgescale-version\n
    rm -rf /etc/rc3.d/S09edgescale\n
    rm -rf /etc/rc5.d/S09edgescale\n
}\n


if [[ "$1" ]]; then\n
    read -p "clean files? " ans\n
    if [[ "${ans:0:1}"  ||  "${ans:0:1}" ]]; then\n
        clean_eds >> eds_install.log 2>&1\n
        echo "Success to remove edgescale client"\n
    fi\n
    exit 0\n
fi\n

echo `date` > eds_install.log\n

read -p "Install files? " ans\n
if [[ "${ans:0:1}"  ||  "${ans:0:1}" ]]; then\n
    untar_payload\n
    if [ -f /usr/local/bin/cert-agent ];then\n
        echo "Success to install edgescale client"\n
    else\n
        echo "Fail to install edgescale client"\n
        exit 1\n
    fi\n
fi\n
\n
exit 0\n
'


function gentar()
{
    if [ $# -eq 1 ]; then
       ROOT="$1"
    else
       ROOT=""
    fi

    list="usr/local/bin/startup.sh
    usr/local/bin/k8s.sh
    usr/local/bin/mq-agent
    usr/local/bin/env.sh
    usr/local/bin/cert-agent
    usr/local/bin/kubelet
    etc/init.d/edgescale
    etc/edgescale-version
    etc/rc3.d/S09edgescale
    etc/rc5.d/S09edgescale
    "

    cd $ROOT
    tar -czvf $work/eds.tgz $list
    cd $work

    echo eds.tgz is generated
}

function geninstaller()
{
    uuencode=1
    if [[ "$1" == '--uuencode' ]]; then
        binary=0
        uuencode=1
        shift
    fi

    if [[ $uuencode -ne 0 ]]; then
        # Append uuencoded data.
        echo -e "\n" $header > $2.sh
        echo "PAYLOAD:" >> $2.sh

        cat $1 | uuencode - >>$2.sh
        chmod a+x $2.sh
        echo $2.sh is generated
    fi

}

while getopts "r:o:h" arg
do
   case $arg in
        o)
           echo "generating installer :$OPTARG"
           geninstaller eds.tgz $OPTARG
           rm eds.tgz
           exit 0
           ;;
        r)
           echo "compress the agent binary :$OPTARG"
           gentar $OPTARG
           ;;
        h)
           echo "Command to generate edgescale eds agent installer."
           echo "    -r agent folder in rootfs folder(Eg: /)"
           echo "    -o output file"
           exit 1
           ;;
        ?)
           echo "tey -h see help"
           exit 1
           ;;
   esac
done


