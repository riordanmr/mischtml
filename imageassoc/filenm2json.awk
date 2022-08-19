# filenm2json.awk - script to generate JSON output from a list of filenames.
# Mark Riordan   2022-08-15
# ls images | grep -v 1x1 | awk -f filenm2json.awk >imageary.js
BEGIN {
    print "var aryimages = "
    print "["
}

{
    if(length(line)>0) print line ","
    line = "       {'img': '" $0 "'}"
}

END {
    if(length(line)>0) print line
    print "];"
}
