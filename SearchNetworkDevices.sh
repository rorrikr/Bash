#!/bin/bash
###################################
#
# RouterOS version:  1.3.6.1.4.1.14988.1.1.4.4.0 (mtxrLicense.mtxrLicVersion)
# Firmware Version: .1.3.6.1.4.1.14988.1.1.7.4.0 (mtxrSystem.mtxrFirmwareVersion)
# Serial Number:    .1.3.6.1.4.1.14988.1.1.7.3.0 (mtxrSystem.mtxrSerialNumber)
#

if [ ! -f /usr/local/bin/sysdata ]; then
    echo "ERROR: /usr/local/bin/sysdata is not installed. Can't proceed..."
    exit 1
fi
if [ `which snmpwalk > /dev/null 2<&1; echo $?` != 0 ]; then
    echo "ERROR: snmpwalk is not installed. Can't proceed..."
    exit 1
fi

SYSTEMID=`sysdata -qs`
RACKSSQTY=`sysdata -q --racksqty`
SNMPCOMUNITY=public
SNMPCOMMAND="snmpwalk -Ov -OQ -v2c -c $SNMPCOMUNITY"


collectMikrotikInfo(){
    IP=$1
    TYPE=$2
    RACK=$3
    if [ "$FORMAT" = "csv" ]; then
        if [ "$count" = "0" ]; then
            echo "IP, Type, Rack, Name, Model, RouterOS, Firmware, S/N"
        fi
        if  ping -c1 -w1 $IP > /dev/null; then
            count=$((count+1))
            echo "$IP, $TYPE, $RACK, \"`$SNMPCOMMAND $IP sysname`\", \"`$SNMPCOMMAND $IP sysdescr`\", \"`$SNMPCOMMAND $IP .1.3.6.1.4.1.14988.1.1.4.4.0`\", \"`$SNMPCOMMAND $IP .1.3.6.1.4.1.14988.1.1.7.4.0`", "`$SNMPCOMMAND $IP .1.3.6.1.4.1.14988.1.1.7.3.0`\""
        fi
    else
        if  ping -c1 -w1 $IP > /dev/null; then
            count=$((count+1))
            echo "==========================================="
            echo "IP:        $IP"
            echo "Type:      $TYPE"
            echo "Rack:      $RACK"
            echo "Name:      `$SNMPCOMMAND $IP sysname`"
            echo "Model:     `$SNMPCOMMAND $IP sysdescr`"
            echo "RouterOS:  `$SNMPCOMMAND $IP .1.3.6.1.4.1.14988.1.1.4.4.0`"
            echo "Firmware:  `$SNMPCOMMAND $IP .1.3.6.1.4.1.14988.1.1.7.4.0`"
            echo "S/N:       `$SNMPCOMMAND $IP .1.3.6.1.4.1.14988.1.1.7.3.0`"
        fi
    fi
}

function printUsage() {
    echo "Usage: $0 <format>"
    echo ""
    echo "  <format> - txt, csv"
    echo ""
}

if [ ! $1 ]; then
    printUsage
    exit 1
fi
FORMAT=$1


#Router
collectMikrotikInfo 172.16.1.100 router 1

# Wi-Fi boxes
count=0
fracks=$(($RACKSSQTY +20))

for (( k=21; k<=$fracks; k++ )); do
    TYPE=wifibox
    RACK=$(($k-20))
    for IP in 172.$k.2.{21..40}; do
        collectMikrotikInfo $IP $TYPE $RACK
    done
done

echo "$count mikrotiks connected to the $SYSTEMID system"
