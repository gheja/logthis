#!/bin/bash

### configuration
url="http://localhost/logthis/log.php?"
logkey="aabbccddeeffgghhiijjkkllmmnnoopp"
logsecret="00112233445566778899001122334455"
### end of configuration

### alter the values above or place your configuration in logthis.conf (in the same format)
[ -e logthis.conf ] && source ./logthis.conf

# read the data
data=`cat | hexdump -ve '1/1 "%.2x"'`

# check the length of data (size is doubled due to hexdump)
length=`echo "$data" | wc -c`
if [ $length -gt 1500 ]; then
	echo "ERROR: Data is longer than 750 bytes -- discarding!"
	exit 2
fi

# create a hash - this way the message can be validated
hash=`echo -n "$data,$logsecret" | md5sum | awk '{ print $1; }'`

# assemble the final url
final_url="${url}${logkey}/${data}/${hash}"

echo "$final_url"

wget_output_file="/tmp/logthis.tmp"
wget -O $wget_output_file -q "$final_url" 

response=`cat $wget_output_file | head -n 1 | cut -d ' ' -f 1`

if [ x$response == xOK ]; then
	uuid=`cat $wget_output_file | head -n 1 | cut -d ' ' -f 2`
	echo "OK: $uuid" >&2
	exit 0
elif [ x$response == xINVALID_LOGKEY ]; then
	echo "ERROR: Invalid logkey." >&2
	exit 3
elif [ x$response == xINVALID_HASH ]; then
	echo "ERROR: Invalid hash. Maybe bad logsecret?" >&2
	exit 4
else
	echo "ERROR: Unkown error occured." >&2
	exit 99
fi
