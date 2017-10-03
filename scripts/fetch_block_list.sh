#!/bin/bash
## get new ad server list
wget -O /etc/squid3/block/ad_block.txt 'http://pgl.yoyo.org/adservers/serverlist.php?hostformat=squid-dstdom-regex&showintro=0&mimetype=plaintext'

tmp_dir=$(mktemp -d)

rm_temp() {
rm -rf "${tmp_dir}"
rm /tmp/adblock.sed && return 0;
}

list=/etc/squid3/block/ad_block_easylist.txt
list2=/etc/squid3/block/ad_block_adware.txt

cat > /tmp/adblock.sed <<'EOF'
/.*\$.*/d;
/\n/d;
/.*\#.*/d;
/@@.*/d;
/^!.*/d;
s/\[\]/\[.\]/g;
s#http://#||#g;
s/\/\//||/g
s/^\[.*\]$//g;
s,[+.?&/|],\\&,g;
s#*#.*#g;
s,\$.*$,,g;
s/\\|\\|\(.*\)\^\(.*\)/\.\1\\\/\2/g;
s/\\|\\|\(.*\)/\.\1/g;
/^\.\*$/d;
/^$/d;
s/\\//g;
EOF

mv $list "$list".old
mv $list2 "$list2".old
cd $tmp_dir
wget -nv https://easylist-downloads.adblockplus.org/easylist.txt || $(mv "$list".old $list && rm_temp)
sed -f /tmp/adblock.sed $(ls) >> $list

wget -nv https://easylist-downloads.adblockplus.org/adwarefilters.txt || $(mv "$list2".old $list2 && rm_temp)
sed -f /tmp/adblock.sed $(ls) >> $list2

#cleaning temps
rm_temp

# refresh squid
/usr/sbin/squid3 -k reconfigure
logger -i "Ad Block List updated"
