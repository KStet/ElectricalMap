#!/bin/bash
out=data.js

#	in=`inotifywait --exclude "^.+\.sw[px]$|4913" -e close_write /home/loud/site/ -q | cut -d ' ' -f3`
	in=data.csv

while :
do
	inotifywait -e close_write data.csv -q
	echo 'eqfeed_callback(
	
	{
	        "type": "FeatureCollection",
	        "features": [' > $out
	
	
	for i in `cat $in | tail -n +2 | tr -s ' ' | tr ' ' '%'`
	do
		i=`echo $i | tr '%' ' '`
		ID=`echo $i | cut -d ',' -f1 | awk '{$1=$1};1'`
		address=`echo $i | cut -d ',' -f2 | awk '{$1=$1};1'`
		lat=`echo $i | cut -d ',' -f3 | awk '{$1=$1};1'`
		lng=`echo $i | cut -d ',' -f4 | awk '{$1=$1};1'`
		voltage=`echo $i | cut -d ',' -f5 | awk '{$1=$1};1'`
	
		echo -ne "\n                        {
	                        \"type\": \"Feature\",
	                        \"properties\": {
	                                ID: \"$ID\",
	                                Address: \"$address\",
	                                Voltage: \"$voltage\"
	                        },
	                        \"geometry\": {
	                                \"type\": \"Point\",
	                                \"LatLng\": [
	                                        $lat,
	                                        $lng
	                                ]
	                        }
	                }," >> $out 
	done
	
	truncate -s-1 $out
	echo -e "\n        ]
	});" >> $out
done
