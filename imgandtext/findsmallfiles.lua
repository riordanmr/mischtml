--[[ 
    findsmallfiles.lua - script to find files that:
    - Are present in a specific directory
    - Appear in a JSON array
    - Have a small size
    /mrr  2022-01-25
]]

--[[ Read JSON containing the names of files we will examine.
 The JSON looks like:
   [
    {'img': 'primg-1f.jpg', 'final': true, 'saying': "Many of"},
    ...
]]

JSON = require 'JSON'

function JSON:onDecodeError(message, text, location, etc)
    print("Custom error handler here" .. "\n")
    print("onDecodeError: " .. message .. "\n")
    print("text: " .. text .. "\n")
    print("location: " .. location .. "\n")
end

function GetJSON()
    -- Read the JSON file, skipping the first line, which the JSON
    -- decoding routine doesn't like.
    local filejs = io.open('prdefs.js')
    local first = true
    local json = ''
    for line in filejs:lines() do
        if first then
            first = false
        else
            json = json .. line
        end
    end
    filejs:close()
    -- Get rid of the trailing semi-colon.
    json = string.sub(json, 1, string.len(json)-1)
    -- Oddly, it appears that the json-lua package requires double quotes (")
    -- in the data, and does not accept single quotes (').
    json = json:gsub("'", '"' )

    -- Decode the JSON string to a LUA table.  The keys to the table will
    -- be integers.
    local tbl = JSON:decode(json)
    return tbl
end

function DetermineSmallFiles()
    -- Read and decode the JSON file containing the names of the files we
    -- are interested in.
    local tblFilesUsed = GetJSON()

    -- Loop through the given directory, looking for the files named in the JSON.
    require 'lfs'
    local subdir = "ImageOnly"
    for file in lfs.dir(subdir) do
        local filename = file
        local bThisIsUsed = false
        local usedfile
        for usedkey, usedvalue in pairs(tblFilesUsed) do
            if usedvalue.img == filename then
                bThisIsUsed = true
            end
        end
        if bThisIsUsed then
            local filesize = lfs.attributes(subdir .. "/" .. filename).size
            if filesize < 200000 then
                print(filename .. " is too small")
            else 
                print("  " .. filename .. " is big enough")
            end
        end
    end
end

DetermineSmallFiles()
