#!/bin/bash
#by Mickael (www.librement-votre.fr)
#set -x

now=$(date +"%B %Y")
username="emailencoded"
password="******"
carteID="000000"
rm -f cookies.txt


token=$(curl -s 'https://www.filbleu.fr/espace-perso' -b cookies.txt -c cookies.txt -H 'Host: www.filbleu.fr' -H 'User-Agent: Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:53.0) Gecko/20100101 Firefox/53.0' -H 'Acc
ept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' -H 'Accept-Language: fr,fr-FR;q=0.8,en-US;q=0.5,en;q=0.3' --compressed -H 'Referer: https://www.filbleu.fr/' -H 'DNT: 1' -H 'Connection: keep
-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'Pragma: no-cache' -H 'Cache-Control: no-cache' | grep -Po '.*name="\K([^"]{32})')

isConnected=$(curl -s -L 'https://www.filbleu.fr/espace-perso?task=user.login' -b cookies.txt -c cookies.txt -H 'Host: www.filbleu.fr' -H 'User-Agent: Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:53.0) Gecko/20100
101 Firefox/53.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' -H 'Accept-Language: fr,fr-FR;q=0.8,en-US;q=0.5,en;q=0.3' --compressed -H 'Content-Type: application/x-www-form-urle
ncoded' -H 'Referer: https://www.filbleu.fr/espace-perso' -H 'DNT: 1' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'Pragma: no-cache' -H 'Cache-Control: no-cache' --data "username=$username&p
assword=$password&return=MzYy&${token}=1" | grep  -c 'login-greeting')
if [ "$isConnected" -eq "1" ]
then
	echo "Connecté !"
else
	echo "Non Connecté"

fi

urlPDF=$(curl -s "https://www.filbleu.fr/espace-perso/mes-cartes/$carteID" -b cookies.txt -c cookies.txt -H 'Host: www.filbleu.fr' -H 'User-Agent: Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:53.0) Gecko/20100101 
Firefox/53.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' -H 'Accept-Language: fr,fr-FR;q=0.8,en-US;q=0.5,en;q=0.3' --compressed -H 'Content-Type: application/x-www-form-urlencod
ed' -H 'Referer: https://www.filbleu.fr/espace-perso' -H 'DNT: 1' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'Pragma: no-cache' -H 'Cache-Control: no-cache' | tr -d '"' | grep -Po '<a href=
\K([^>]+)' | grep "/espace-perso/mes-cartes/pdfs/prelevement")

while read -r urlOnePDF; do
	curl -s "https://www.filbleu.fr$urlOnePDF" -O -J -b cookies.txt -c cookies.txt -H 'Host: www.filbleu.fr' -H 'User-Agent: Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:53.0) Gecko/20100101 Firefox/53.0' -H '
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' -H 'Accept-Language: fr,fr-FR;q=0.8,en-US;q=0.5,en;q=0.3' --compressed -H 'Content-Type: application/x-www-form-urlencoded' -H 'Referer: h
ttps://www.filbleu.fr/espace-perso' -H 'DNT: 1' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'Pragma: no-cache' -H 'Cache-Control: no-cache'
done <<< "$urlPDF"
echo "Attestations récupérées" | /usr/bin/mutt -s "Attestation récupérées" -- email@domain.fr
rm -f cookies.txt
