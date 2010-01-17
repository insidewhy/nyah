#!/bin/sh

run_mousebear=../.obj/mousebear/mousebear

if [ x$1 == x-v ] ; then
    verbose=1
fi

for input in *.nyah ; do
    output=${input%.nyah}.out
    $run_mousebear $input > $output.new
    if [ ! -e $output ] ; then
        mv $output.new $output
        echo "new result for input $input"
        cat $output
    elif ! diff -q $output $output.new ; then
        echo "results differ"
        diff $output $output.new
        exit 1
    else
        echo "$input passed"
        if [ -n "$verbose" ] ; then
            cat $output
            echo
        fi
        rm $output.new
    fi
done
