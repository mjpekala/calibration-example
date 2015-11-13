#!/bin/bash

HOST=http://www-stat.stanford.edu/~tibs/ElemStatLearn/datasets/

curl -OL $HOST/zip.train.gz
curl -OL $HOST/zip.test.gz

gunzip zip.train.gz
gunzip zip.test.gz
