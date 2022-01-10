-- imgtohtml.lua - Program to accept an input file containing
-- image filenames and descriptions, and output a series of HTML files,
-- one per image, containing the image and description.
-- Mark Riordan  2022-01-07
-- Usage:  lua imgtohtml.lua
--
-- Note: I later decided to use a different approach using only one
-- HTML file & JavaScript, thus obsoleting this program.
function MakeHTMLForImage(ifile, imgfilename, saying)
    outputfn = "page" .. ifile .. ".html"
    file = io.open(outputfn, "w")
    file:write('<html>', "\n")
    file:write('<head>', "\n")
    title = string.sub(saying,1,20)
    file:write('<title>' .. title .. '</title>', "\n")
    file:write('<style>')
    file:write('body, td { font-family: sans-serif; font-size: 28pt; }', "\n")
    file:write('img {', "\n")
    file:write('    max-width: 100%;', "\n")
    file:write('    max-height: 100%;', "\n")
    file:write('}', "\n")
    file:write('</style>', "\n")
    file:write('</head>', "\n")
    file:write('<body>', "\n")
    file:write('<table width="100%">', "\n")
    file:write('  <tr>', "\n")
    file:write('    <td width="80%"><img src="' .. imgfilename .. '"/></td>', "\n")
    file:write('    <td>' .. saying .. '</td>', "\n")
    file:write('  </tr>', "\n")
    file:write('</table>', "\n")
    file:write('</body>', "\n")
    file:write('</html>', "\n")
    io.close(file)
end

ifile = 0
for line in io.lines("theprobleminput.txt") do
    ifile = ifile +1
    istart, iend = string.find(line,",")
    filename = string.sub(line,1,istart-1)
    saying = string.sub(line, istart+1)
    --print(filename, saying)
    MakeHTMLForImage(ifile, filename, saying)
end
