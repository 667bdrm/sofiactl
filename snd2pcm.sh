#!/bin/sh

sox $1 -t al -r 8000 -c 1 `echo $1 | cut -f1 -d .`.pcm


