#!/usr/bin/env python

import urllib2, re, os

def addrules(url):
    html = urllib2.urlopen(url,timeout=60).readlines()
    for line in html:
        line=line.strip()
        if line=='': continue
        if line.find('$')>=0: continue
        if line.find('#')>=0: continue
        if line.find('@@')>=0: continue
        if line.find('[]')>=0: continue
        if line.startswith('!'): continue
        if line.startswith('['): continue
        line=line.replace('.','\.')
        line=line.replace('^','.')
        line=line.replace('|http','http')
        line=line.replace('||','')
        line=line.replace('*','.*')
        line=line.replace('?','\?')
        line=line.replace('|','')
	line=line.replace('+','')
        print line

if __name__ == '__main__':
    addrules("https://easylist-downloads.adblockplus.org/easylist.txt")
    addrules("https://easylist-downloads.adblockplus.org/adwarefilters.txt")
    addrules("https://easylist-downloads.adblockplus.org/malwaredomains_full.txt")
