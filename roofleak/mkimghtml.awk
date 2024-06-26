# mkimghtml.awk - script to create an HTML web page from
# a list of image files and a skeleton.
# Mark Riordan  28 Dec 2022
# Usage:  awk -f mkimghtml.awk imageinfo.txt >index.html
BEGIN {
    FS = "|"
    skel = "indexskel.html"
    do {
        getline line <skel
        if(index(line,"end header")>0) break
        print line
    } while(1)
}

{
    filename = $1
    desc = $2
    print "<p> <a href=\"" filename "\"><img src=\"thumbs/" filename "\"></a><br/>"
    print "<span>" desc "</span>"
    print "</p>"
}

END {
    doprint = 0
    do {
        if(0==getline line <skel) break
        if(doprint) print line
        if(index(line,"start trailer")>0) doprint = 1
    } while(1)
}
