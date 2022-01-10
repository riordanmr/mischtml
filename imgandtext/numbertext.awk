# numbertext.awk - script to make a copy of an input file, prepending
# the line number on each line.
# Mark Riordan   2022-01-09
# awk -f numbertext.awk <problem-raw.txt >problem-num.txt
{
    print NR ". " $0
}
