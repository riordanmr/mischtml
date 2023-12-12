# mklinks.awk - script to create HTML containing links to files.
# Input is a list of filenames.  The names may contain %20 sequences;
# these are converted to spaces in the link text.
# Mark Riordan  12 Dec 2023
# awk -f mklinks.awk files.txt
{
    filename = $0
    text = filename
    gsub(/%20/," ",text)
    print "<a href=\"" filename "\">" text "</a><br/>"
}
