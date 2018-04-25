#!/bin/bash
out=data.js

#	in=`inotifywait --exclude "^.+\.sw[px]$|4913" -e close_write /home/loud/site/ -q | cut -d ' ' -f3`
	in=data.csv

while :
do
	inotifywait -e close_write data.csv -q
	data='eqfeed_callback(\n
	\n
	{\n
	\t        "type": "FeatureCollection",\n
	\t        "features": ['
	
	for i in `cat $in | tail -n +2 | tr -s ' ' | tr ' ' '%'`
	do
		i=`echo $i | tr '%' ' '`
		ID=`echo $i | cut -d ',' -f1 | awk '{$1=$1};1'`
		address=`echo $i | cut -d ',' -f2 | awk '{$1=$1};1'`
		lat=`echo $i | cut -d ',' -f3 | awk '{$1=$1};1'`
		lng=`echo $i | cut -d ',' -f4 | awk '{$1=$1};1'`
		voltage=`echo $i | cut -d ',' -f5 | awk '{$1=$1};1'`
	
		data="$data\n\t\t                        {\n
	                       \t\t\t\"type\": \"Feature\",\n
	                        \t\t\t\"properties\": {\n
	                        \t\t\t\t        ID: \"$ID\",\n
	                        \t\t\t\t        Address: \"$address\",\n
	                        \t\t\t\t        Voltage: \"$voltage\"\n
	                        \t\t\t},\n
	                        \t\t\t\"geometry\": {\n
	                               \t\t\t\t \"type\": \"Point\",\n
	                               \t\t\t\t \"LatLng\": [\n
	                               \t\t\t\t\t         $lat,\n
	                               \t\t\t\t\t         $lng\n
	                               \t\t\t\t ]\n
	                        \t\t\t}\n
	                \t\t}," 
	done
	echo -ne $data > $out
	truncate -s-1 $out
	echo -e "\n        ]
	});" >> $out
done
