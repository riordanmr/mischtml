# txt2links.awk - script to create HTML links from an input file.
# The input consists of lines like:
# 1945-11-02.html
# The output consists of lines like:
# <a href="1945-11-02.html">1945-11-02</a> <br/>
#
# Usage:  awk -f txt2links.awk j
{
    line = $0
    match(line,"[0-9-]+")
    base = substr(line,RSTART,RLENGTH)
    out = "<a href=\"" line "\">" base "</a> <br/>"
    print out
}