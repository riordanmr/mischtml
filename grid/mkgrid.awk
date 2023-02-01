# mkgrid.awk - script to create an HTML table of grid lines.
# This is to mock up a birthday card.
# Mark Riordan  31 Jan 2023
# awk -f mkgrid.awk
BEGIN {
    for(y=1; y<=16; y++) {
        print "    <tr>"
        for(x=1; x<=28; x++) {
            id = "x" x "y" y
            print "      <td id=\"" id "\" onclick=\"oncellclick('" id "');\"></td>"
        }
        print "    </tr>"
    }
}