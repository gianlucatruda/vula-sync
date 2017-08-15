#!/usr/local/bin/bash
# Vula course resource synchroniser
# Version 5.0
# Gianluca Truda
# 14 August 2017

# Fill in the details below

MAM="48efc4a8-7cd8-4897-a873-227f1681d91e"
CSC="36d78fc9-75b1-4f6c-a810-e71ed865d415"
MCB="cf74494c-7c8c-4bfe-bd61-87b04a8ed405"
DIR="/Users/gianlucatruda/Documents/GIANLUCA/Current/resources"

#-------------------------------

DATE="`date '+%Y_%m_%d__%H_%M_%S'`"
TIMEOUTCOUNT=0
NETNAME=`/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk '/ SSID/ {print substr($0, index($0, $2))}'`

function SYNC {
	clear
	echo
	echo $DATE
	echo
	echo Mounting Drives…
	osascript -e ' mount volume "https://vula.uct.ac.za/dav/'$MAM'" '
	osascript -e ' mount volume "https://vula.uct.ac.za/dav/'$CSC'" '
	osascript -e ' mount volume "https://vula.uct.ac.za/dav/'$MCB'" '
	cd /Users/gianlucatruda/Desktop
	echo Synchronising…
	rsync -avzh --progress //Volumes/$MAM/* $DIR/mam
	rsync -avzh --progress //Volumes/$CSC/* $DIR/csc
	rsync -avzh --progress //Volumes/$MCB/* $DIR/mcb
	echo Unmounting Drives…
	umount /Volumes/$MAM
	umount /Volumes/$CSC
	umount /Volumes/$MCB

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
