#!/bin/bash 
# Vula course resource synchroniser
# Version 4.3
# Gianluca Truda
# 16 November 2016

#Fill in the details below

CSC="657cec78-8f33-43ac-8934-d28a658f08ea"
#MAM="c2c4b7e5-d33c-4e7a-9132-0da22546ae29"
#MCB="23746890-8099-48ea-935a-484ff9a6451b"
DIR="/Users/gianlucatruda/Documents/GIANLUCA/Current/resources"

#-------------------------------

DATE="`date '+%Y_%m_%d__%H_%M_%S'`"
TIMEOUTCOUNT=0
NETNAME=`/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk '/ SSID/ {print substr($0, index($0, $2))}'`

function SYNC {

	echo 
	echo $DATE
	echo
	echo Mounting Drives…
	osascript -e ' mount volume "https://vula.uct.ac.za/dav/'$CSC'" '
	#osascript -e ' mount volume "https://vula.uct.ac.za/dav/'$MAM'" '
	#osascript -e ' mount volume "https://vula.uct.ac.za/dav/'$MCB'" '
	cd /Users/gianlucatruda/Desktop
	echo Synchronising…
	rsync -avzh --progress //Volumes/$CSC/* $DIR/csc2002
	#rsync -avzh --progress //Volumes/$MAM/* $DIR/mam1005
	#rsync -avzh --progress //Volumes/$MCB/* $DIR/mcb2023
	echo Unmounting Drives…
	umount /Volumes/$CSC
	#umount /Volumes/$MAM
	#umount /Volumes/$MCB


	echo Sync Complete on $DATE
	echo
	echo _______________________________
	TIMEOUTCOUNT=0

}

function CHECK {
	wget -q --spider http://google.com

	if [ “$?” == “0” ] 
	then
		echo
		echo Active network — $NETNAME
		SYNC
	elif [ “$?” != “0” ]
	then
		echo
		if [ $TIMEOUTCOUNT -lt 5 ] 
		then
			((TIMEOUTCOUNT+=1))
			sleep 60
			echo Time Outs: $TIMEOUTCOUNT
			CHECK
		elif [ $TIMEOUTCOUNT -ge 5 ]
			then
			echo Network Down on $DATE
			echo _______________________________
		fi
	fi

}

CHECK