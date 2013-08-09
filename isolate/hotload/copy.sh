#!/bin/bash

from="hotloaded_node.dart"

for i in $(seq 0 9)
do
  cp -f $from $i$from
done

