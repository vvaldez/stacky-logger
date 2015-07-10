#!/bin/bash -x

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

for TENANT in ${TENANTS}
do
  if [ ! -d ${TENANT} ]
  then
    mkdir ${TENANT}
  fi
  for SERVICE in ${SERVICES}
  do
    if [ ! -d ${SERVICE} ]
    then
      mkdir ${TENANT}/${SERVICE}
    fi
    echo "INFO: Logs for Tenant: ${TENANT} for Service: ${SERVICE} on ${DATE}"> ${TENANT}/${SERVICE}/${DATE}.log
    python stacky.py search nova tenant ${TENANT}>> ${TENANT}/${SERVICE}/${DATE}.log
    for EVENT in $(python stacky.py search nova tenant ${TENANT} | awk '{ print $2 }')
    do
      echo "INFO: Nova Event ${EVENT}:">> ${TENANT}/${SERVICE}/${DATE}.log
      python stacky.py show ${EVENT}>> ${TENANT}/${SERVICE}/${DATE}.log
    done
  done
done
