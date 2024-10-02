#!/bin/sh

if [ "$(uname)" = 'Linux' ]; then
    sanitize='-fsanitize=address -fsanitize=undefined -fsanitize-trap'
    clibs='-lm' # -pthread
    oflag='-o '
fi
common="-std=c99 -Werror -Wall"
#cc=clang; cflags="-s -O3 $common"
cc=gcc; cflags="-s -O3 $common"
#cc=gcc; cflags="-g $sanitize $common"
#cc=gcc; cflags="-x c++ -std=c++20 -O2 -s"
#cc=tcc; cflags="-std=c99 -Wall"
#cc=cl; cflags="-nologo -O2 -MD -W3 -std:c11 -wd4003"
#cc=cl; cflags="-nologo -O2 -MD -W3 -wd4003"
#cc=cl; cflags="-nologo -TP -std:c++20 -wd4003"

if [ "$cc" = "cl" ]; then
    oflag='/Fe:'
else
    oflag='-o '
fi

run=0
if [ "$1" = '-h' -o "$1" = '--help' ]; then
  echo usage: runall.sh [-run] [compiler + options]
  exit
fi
if [ "$1" = '-run' ]; then
  run=1
  shift
fi
if [ ! -z "$1" ] ; then
    comp="$@"
else
    comp="$cc $cflags"
fi

INC=
#INC=-I../../include
#INC=-I../../../stcsingle
#CPATH=
if [ $run = 0 ] ; then
    for i in */*.c ; do
        out=$(basename $i .c).exe
        #out=$(dirname $i)/$(basename $i .c).exe
        #echo $comp -I../../../stcsingle $i $clibs $oflag$out
        echo $comp -I$INC $i $clibs $oflag$out
        $comp $INC $i $clibs $oflag$out -lstc
    done
else
    for i in */*.c ; do
        out=$(basename $i .c).exe
        #out=$(dirname $i)/$(basename $i .c).exe
        echo $comp -I$INC $i $clibs $oflag$out
        $comp $INC $i $clibs $oflag$out -lstc
        if [ -f $out ]; then ./$out; fi
    done
fi

#rm -f a.out *.o *.obj # *.exe
