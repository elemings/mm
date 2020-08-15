#!/bin/sh

test -d ./build-aux || mkdir ./build-aux
test -f ./build-aux/shtool || cp -p `which shtool 2>/dev/null` ./build-aux 2>/dev/null

test -d ./m4 || mkdir ./m4

# GNU Autoconf Archive is required and can be downloaded from
# https://www.gnu.org/software/autoconf-archive/Downloads.html

AUTOMAKE="automake --foreign" autoreconf -i $*
exit $?

