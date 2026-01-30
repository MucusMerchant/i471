#!/usr/bin/sh

if [ $# -ne 1 ]
then
    echo "usage: lexer2.py DATA_FILE"
    exit 1
fi

# uncomment following line for javascript
# node ./lexer2.mjs $1

# uncomment following line for python
python3 ./lexer2.py $1

# uncomment following line for java
# java ./lexer2.java $1

