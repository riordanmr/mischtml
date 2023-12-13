# find images -maxdepth 1 -not -type d -and -not -name '.*' | grep -v 1x1 | sort | awk -f filenm2json.awk >imageary.js
ls images | grep -v 1x1 | grep -v NotUsed | awk -f filenm2json.awk >imageary.js
