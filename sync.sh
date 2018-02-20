#!/usr/local/bin/bash
# Vula course resource synchroniser
# Version 6.0
# Gianluca Truda
# 20 February 2018

# Fill in the details below

CSC="8139d0af-88f1-492c-9ee6-58f1655428e8"
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
	echo Clearing Volumes...
	rmdir //Volumes/*
	echo
	echo Mounting Drives...
	osascript -e ' mount volume "https://vula.uct.ac.za/dav/'$CSC'" '
	cd /Users/gianlucatruda/Desktop
	echo Synchronising…
	rsync -avzh --progress //Volumes/$CSC'-1'/* $DIR/csc
	# echo Unmounting Drives…
	# diskutil unmount //Volumes/$CSC'-1'
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
