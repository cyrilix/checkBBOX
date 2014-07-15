#! /bin/bash

# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
# 
#   http://www.apache.org/licenses/LICENSE-2.0
# 
#   Unless required by applicable law or agreed to in writing,
#   software distributed under the License is distributed on an
#   "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
#   KIND, either express or implied.  See the License for the
#   specific language governing permissions and limitations
#   under the License.

# Script de monitoring et de reboot de bbox

. ${XDG_CONFIG_HOME:-$HOME/.config}/checkBBox

BBOX_IP=${IP_BBOX:-192.168.1.254}
HOST_TO_PING=${HOST_TO_PING:-www.google.fr}

reboot_bbox(){
	# Authentification
	COOKIE="/var/tmp/cookie-bbox"
	if [ -e ${COOKIE} ] ; then 
		echo "Suppression du cookie précédant"
		rm ${COOKIE}
	fi
	curl -d "login=admin&password=${PASSWORD}" -c ${COOKIE}  http://${BBOX_IP}/cgi-bin/login.cgi 2>&1 > /dev/null
	
	# Récupération du jeton
	echo "Récupération du jeton"
	TOKEN=`curl  --cookie ${COOKIE} http://${BBOX_IP}/novice/gtw.htm 2>/dev/null | egrep  "var token = eval\('\([[:blank:]]*.*\)'\);" | sed "s#.*\"\([[:alnum:]_]*\)\".*#\1#g" | head -n 1`

	# Reboot
	echo "Reboot de la box"
	curl -v -d "token=${TOKEN}&fct=reboot" -b ${COOKIE}  http://${BBOX_IP}/cgi-bin/generic.cgi 2> /dev/null
	if [ $? = 0 ] ; 
	then 
		echo "Redémarrage en cours..." 
		# Pause de 2mn pour permettre le redémarrage complet et l'envois du mail
		sleep 120
	else 
		echo "Échec du redémarrage"
	fi

	rm ${COOKIE}

}


check_connection(){
	ping -c1 $HOST_TO_PING -W1 2>&1 > /dev/null
	if [ $? != 0 ] ; then
		echo "Impossible de joindre $HOST_TO_PING "
		reboot_bbox
	fi
}

check_connection

