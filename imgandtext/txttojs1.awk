# txttojs1.awk - simple script to output JavaScript for imgandtext.
# MRR  2022-01-09
# Input file contains lines that look like:
# 1. This is the text associated with Image One.
#
# Updated to accept lines without the number and period.
#
# Usage: awk -f txttojs1.awk problem-num.txt
{
    line = $0
    #idx = index(line, ".")
    #num = substr(line, 1, idx-1)
    #txt = substr(line, idx+2)
    #print "    {'img': 'primg-" num "a.PNG', 'saying': \"" txt "\"},"
    num = NR
    txt = line
    print "    {\"img\": \"seimg-" num "a.jpg\", \"final\": false, \"saying\": \"" txt "\"},"
}
