#! /bin/bash

export totalEvents=1000000

export logLevel=info
export randomSeed=661
export concurrencyLevel=100

time java -server -Xmx1G -jar ./follower-maze-2.0.jar
