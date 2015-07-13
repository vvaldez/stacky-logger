#!/bin/bash

# script to grab events out of the stacktach database
# Written by Vinny Valdez <vvaldez@redhat.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

TENANTS="d50ea282853e4f16938d70c3c1d1e1cd e63bb450e0f44df2adf586852f87861c 2cee3e9e29dd4e8eb125dc0d5daede06"
SERVICES="nova glance"
DATE=$(date +%F)
STACKTACH_URL=http://10.12.36.12/

for TENANT in ${TENANTS}
do
  for SERVICE in ${SERVICES}
  do
    if [ ! -d logs/${SERVICE} ]
    then
      mkdir -p logs/${TENANT}/${SERVICE}
    fi
    for EVENT in $(python stacky.py search nova tenant ${TENANT} | awk '{ print $2 }' | grep [0-9]$)
    do
      echo "INFO: Writing event ${EVENT} for ${SERVICE} on tenant ${TENANT} to logs/${TENANT}/${SERVICE}/${DATE}.log"
      python stacky.py show ${EVENT} | grep -ve "|" -ve "+">> logs/${TENANT}/${SERVICE}/${DATE}.log
    done
  done
done
