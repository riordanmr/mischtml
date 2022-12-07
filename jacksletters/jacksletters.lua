--[[
    jacksletters.lua - Lua program to create HTML files from letters
    written by Jack Riordan.
    The input is a single file containing all of the transcribed letters.
    Each letter starts with these lines:
    ==date 1945-11-02   (giving the date of the letter)
    ==images 3          (giving the number of images associated with the letter)
    Following those lines are the ASCII text of the letter, one line per
    paragraph.  We output each line as an HTML p element.
    At the end of each letter (denoted by the next ==date line, or a ==eof line),
    we output HTML image references for each of the images.
    The image filenames are derived from the date: the first would look like
    1945-11-02a.jpg, the second 1945-11-02b.jpg, and so on.

    Written by Mark Riordan   2022-12-05
]]

-- See https://stackoverflow.com/questions/22831701/
function string.starts(String,Start)
    return string.sub(String,1,string.len(Start))==Start
end

function outLine(txt)
    fileOut:write(txt,"\n")
end

function parseCmd(line)
    local isCmd, idxstart, idxend, cmd, arg1
    idxstart, idxend, cmd, arg1 = string.find(line,"^==(%a+)%s+(.+)")
    --print("input=",line,' idxstart=',idxstart,' cmd=',cmd,' arg=',arg1)
    isCmd = true
    if nil == idxstart then 
        isCmd = false
    end
    return isCmd, cmd, arg1
end

function scanForDates()
    local isCmd, cmd, arg1
    aryDates = {}
    for line in filein:lines() do
        isCmd, cmd, arg1 = parseCmd(line)
        if isCmd then 
            if cmd=='date' then
                table.insert(aryDates, arg1)
            end
        end
    end
    for _, mydate in ipairs(aryDates) do
        print("scanForDates recorded",mydate)
    end
end

function startLetter(curDate)
    filenmOut = 'output/' .. curDate .. ".html"
    fileOut = io.open(filenmOut,"w")
    nLetters = nLetters + 1
    numImages = 0
    print('Created ',filenmOut)
    outLine('<html>')
    outLine('<head>')
    outLine(os.date('  <!-- Generated by MRR using jacksletters.lua on %Y-%m-%d %H:%M:%S -->'))
    outLine('  <!-- Bring in Adobe fonts. -->')
    outLine('  <link rel="stylesheet" href="https://use.typekit.net/knj3pnz.css">')
    outLine('  <link rel="stylesheet" href="jacksletters.css">')
    outLine('  <meta name="viewport" content="width=device-width, initial-scale=1">')
    outLine('  <title>'..curDate..'</title>')
    outLine('</head>')
    outLine('<body>')
    outLine('  <div class="container">')
    outLine('  <table width="100%">')
    outLine('    <tr>')
    -- Locate the previous and next filenames, to create navigation
    local prevDate,nextDate,gotDate,tempPrev
    tempPrev = ''
    prevDate = ''
    nextDate = ''
    gotDate = false
    for _, mydate in ipairs(aryDates) do
        if mydate==curDate then
            gotDate = true
            prevDate = tempPrev
        else
            if gotDate then
                nextDate = mydate
                break
            end
        end
        tempPrev = mydate
    end
    --print("For date "..curDate..", prev="..prevDate.." next="..nextDate)
    -- Create Previous, Top, and Next links at the top of the page.
    prevText = ''
    if prevDate ~= '' then
        prevText = '<a href='..prevDate..'.html>Previous</a>'
    end
    outLine('      <td width="25%" class="navleft">' .. prevText .. '</td>')
    outLine('      <td width="50%" class="navcenter"><a href="index.html">Letters from Jack Riordan</a></td>')
    nextText = ''
    if nextDate ~= '' then
        nextText = '<a href='..nextDate..'.html>Next</a>'
    end
    outLine('      <td width="25%" class="navright">' .. nextText .. '</td>')
    outLine('    </tr>')
    outLine('  </table>')
end

function finishLetter()
    outLine('    <hr/>')
    outLine('  </div>')
    outLine('  <div>')
    outLine('    <p class="original">Images of above transcribed letter:</p>')
    alphabet = 'abcdefghijklmnopqrstuvwxyz'
    for j=1,numImages do
        filename = curDate .. string.sub(alphabet,j,j) .. '.jpg'
        outLine('    <br/>')
        outLine('    <img src="images/' .. filename .. '" width="100%"/>')
    end
    outLine('  </div>')
    outLine('</body>')
    outLine('</html>')
    fileOut:close()
end

function main()
    local isCmd, cmd, arg1
    nLetters = 0
    inLetters = false
    indenting = false
    filein = io.open('letters.txt')
    -- Scan the entire file for letters, so we'll be able to link to the 
    -- next letter.
    scanForDates()
    -- Rewind the input file and read again, this time creating output files.
    filein:seek("set",0)
    for line in filein:lines() do
        isCmd, cmd, arg1 = parseCmd(line)
        if isCmd then 
            print("main got cmd",cmd)
            if cmd=='date' then
                inLetters = true
                -- Initial paragraphs of a letter are not indented.
                indenting = false
                if filenmOut ~= nil then
                    -- Close existing file
                    finishLetter()
                end
                curDate = arg1
                startLetter(curDate)
            elseif cmd=='images' then
                numImages = tonumber(arg1)
            elseif cmd=='eof' then
                finishLetter()
                inLetters = false
            else
                print("** Error at ",line)
            end
        elseif inLetters then
            -- We are inside a letter.  Make the input line into HTML, 
            -- computing its CSS class via simple heuristics.
            html = line:gsub('&','&amp;')
            if indenting then
                myclass = 'indent'
            else
                myclass = 'left'
            end
            html = '    <p class="' .. myclass .. '">' .. html .. '</p>'
            --print(html)
            isDearLine = line:starts("Dear")
            if isDearLine then
                outLine('    <br/>')
            end
            outLine(html)
            if isDearLine then
                -- After "Dear", all additional paragraphs are indented.
                indenting = true
            end
        end
    end
    filein:close()
end

main()