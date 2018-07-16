#!/usr/bin/python3

## Keep Primary Annotations
## cjfiscus and crvaldez
## 7/09/2018

import sys

File=open(sys.argv[1])

for Line in File:
    ## string processing
    parts=Line.split("\t")

    # build string to determine if alternatively spliced
    check_str = parts[8].split(":")[1].split(";")[0].strip("\n").split("-")[1]

    # search for string at end of transcript, no alternative spliceoforms, only included -00 and -01
    if (check_str == "00" or check_str == "01"):
        print(Line.strip("\n"))
