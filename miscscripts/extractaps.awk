# extractaps.awk - script to extract info from Arizona Power Service bill.
# Mark Riordan  2022-05-13
# sample input:
# <tr><td class=" single-line td-width firstTabPos "><span class="title-font">Billed on</span><br><span class="month-font"> May 04, 2022 </span><hr class="hiddenmd line-class"></td><td class="cta-text   relative-pos"><a href="#" class="aps-link-icon absolute-pos cta-1" aria-label="View bill" id=""><span class="aps-btn-link" id="">View bill</span></a></td><td class="cta-text   relative-pos td-width-md pl-grid"><a href="/en/Residential/Billing-and-Payment/Understanding-Your-Bill" class="absolute-pos cta-2" target="_blank" rel="noopener noreferrer">Understanding your bill</a></td><td class="month-font column-text relative-pos lastTabPos"><div class="absolute-pos td-column"> $-45.86</div></td></tr>
#
# awk -f extractaps.awk aps202205.xml
/tr>/ {
    line = $0
    pattern = "class=\"month-font\"> "
    idx = index(line, pattern)
    line = substr(line, idx+length(pattern))
    idx = index(line, "<")
    date = substr(line, 1, idx-1)
    line = substr(line, idx)

    pattern = "absolute-pos td-column\"> "
    idx = index(line, pattern)
    line = substr(line, idx+length(pattern))
    idx = index(line, "<")
    dollars = substr(line, 1, idx-1)

    print date "\t" dollars
}
