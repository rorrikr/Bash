#!/bin/bash

finArr=()
re='^[0-9]+$'

checkNum(){
if ! [[ $1 =~ $re ]]
	then
	echo "-== Incorrect port expression! =-"
	exit 2
else
	return 
fi
}

rangeCase(){
IFS='-' read -ra SPLI2 <<<"$1"
checkNum ${SPLI2[0]}
checkNum ${SPLI2[1]}

if [ ${SPLI2[0]} -gt ${SPLI2[1]} ]
    then
    echo "-== Incorrect port expression! ==-"
    exit 2
 fi
    
for ((c=${SPLI2[0]};c<=${SPLI2[1]};c++))
do 
finArr+=($c)
done
}



#Check arguments
if [ $# -gt 3 ] || [ $# -lt 3 ]
	then
	echo "trun - tests run utility for core2/3/4 labs."
	echo "    Usage: "
	echo "          trun <lab> <rack> <ports> "
	echo ""
	echo "	  Where <lab> - lab name <core2/core3/core4>"
	echo "                <rack> - rack number <1/2> "
	echo "          	<ports> - port number <1-20> "
	echo "    Expressions: "
	echo "-== trun core2 2 1,5,9        ==-"
	echo "-== trun core3 1 1-8,11,13-20 ==-"
	exit 1
fi

#Check lab
if [ $1 == "core2" ]
then 
        echo "-== Working with core2 lab ==-"
	lab=core2.oside.crp:7443
elif [ $1 == "core3" ]
	then
        echo "-== Working with core3 lab ==-"
	lab=core3.oside.crp:7443
elif [ $1 == "core4" ]
        then
        echo "-== Working with core4 lab ==-"
        lab=core4.oside.crp:7443

else
	echo "-== Incorrect lab! ==-"
	exit 1
fi

#Check rack

if ! [[ $2 =~ $re ]] || [ "$2" -lt 1 ] || [ "$2" -gt 3 ]
	then
	echo "-== Incorrect rack number! ==-"
	exit 1
fi	

#Main
IFS=',' read -ra SPLI <<<"$3"
#sLength=${#SPLI[@]}
for i in "${SPLI[@]}";do
#echo "$i"
size=${#i}
#echo "Length of this is $size"

if [ "$size" -gt 2 ];
then
rangeCase $i
else
checkNum $i
finArr+=($i)
fi
done 

#Output
for i in "${finArr[@]}"
do
	if [ "$i" -lt 1 ] || [ "$i" -gt 20 ]  
		then
		echo "-== Incorrect port number [$i]! ==-"
		continue
	fi
curl -I -k -s https://$lab/rest/port_action/start/$2/$i > /dev/null &
PID=$!
j=1
sp="/-\|"
echo -n ' '

while [ -d /proc/$PID ]
do
  printf "\b${sp:j++%${#sp}:1}"
done

echo "-> port $i done"
done

echo "-== All done! ==-"