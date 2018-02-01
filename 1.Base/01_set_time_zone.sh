#!/bin/bash

# set timezone
echo "US/Pacific" > /etc/timezone
#echo "#{CFG_TZ}" > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata
