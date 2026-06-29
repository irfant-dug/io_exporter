#!/bin/bash

rm -f /var/tmp/.ftrace-lock
/opt/io_exporter/iosnoop -ts 10 > /tmp/io_exporter/iosnoop.raw
/opt/io_exporter/iosnoop_processing.sh /tmp/io_exporter/iosnoop.raw > /tmp/io_exporter/iosnoop.json

