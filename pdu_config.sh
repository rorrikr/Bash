#!/bin/bash

ping_check(){
if ping -c1 -w3 $1 > /dev/null; then
    echo "Host $1 is available"
else 
    echo "Host $1 is unreachable"
    exit 14
fi
}

if [ -z "$1" ];
	then
	ping_check 192.168.1.100
	curl -u admin:admin -s -d "dhcp=1&stip=192.168.1.100&mask=255.255.0.0&gway=192.168.1.1&dnsE=0&dns1=0.0.0.0&dns2=0.0.0.0&webP=80&webS=443&telP=23&ipft=0.0.0.0&ipfm=255.255.255.255&smtP=25&ssvr=&smtA=1&sact=&spwd=&eml1=&eml2=&mibE=1&mibR=public&mibW=public&trpE=0&trIP=0.0.0.0&trSt=pdu+trap" http://192.168.1.100/nw.htm > /dev/null
	else
	val=0    	
    		if [ $# -gt 2 ];
			then 
			echo "Too many arguments"
			exit 13
			else
			[[ "$1" =~ ^(([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])$ ]] &&  val=1 || val=0
			if [ $val == 1 ];
				then
                                        ping_check $1
					if [ $# -eq 2 ];
						then
						curl -u admin:$2 -s -d "dhcp=1&stip=192.168.1.100&mask=255.255.0.0&gway=192.168.1.1&dnsE=0&dns1=0.0.0.0&dns2=0.0.0.0&webP=80&webS=443&telP=23&ipft=0.0.0.0&ipfm=255.255.255.255&smtP=25&ssvr=&smtA=1&sact=&spwd=&eml1=&eml2=&mibE=1&mibR=public&mibW=public&trpE=0&trIP=0.0.0.0&trSt=pdu+trap" http://$1/nw.htm > /dev/null
						else
                                                curl -u admin:admin -s -d "dhcp=1&stip=192.168.1.100&mask=255.255.0.0&gway=192.168.1.1&dnsE=0&dns1=0.0.0.0&dns2=0.0.0.0&webP=80&webS=443&telP=23&ipft=0.0.0.0&ipfm=255.255.255.255&smtP=25&ssvr=&smtA=1&sact=&spwd=&eml1=&eml2=&mibE=1&mibR=public&mibW=public&trpE=0&trIP=0.0.0.0&trSt=pdu+trap" http://$1/nw.htm > /dev/null
					fi
				else
				echo "Invalid IP address"
				exit 13
			fi			
		fi
fi