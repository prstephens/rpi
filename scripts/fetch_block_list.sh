#!/bin/bash
## get new ad server list
wget -O /etc/squid3/block/ad_block.txt 'http://pgl.yoyo.org/adservers/serverlist.php?hostformat=squid-dstdom-regex&showintro=0&mimetype=plaintext'
# refresh squid
/usr/sbin/squid3 -k reconfigure
logger -i "Ad Block List updated"
