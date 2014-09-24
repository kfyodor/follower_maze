#! /bin/bash

export totalEvents=10000

export logLevel=info
# export randomSeed=666

time java -server -Xmx1G -jar ./follower-maze-2.0.jar
