#!/bin/sh

DIR=$(dirname $0)

SPECLIST="define(["

for spec in `find $DIR/javascript/specs -name "*.js"`
do
    spec=${spec#$DIR/javascript/}
    spec=${spec%.js}
    SPECLIST=$SPECLIST"'$spec',"
done

SPECLIST=${SPECLIST%,}"], function() { });"

echo $SPECLIST > $DIR/javascript/speclist.js
