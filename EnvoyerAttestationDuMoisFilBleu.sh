#!/bin/bash
#by Mickael (www.librement-votre.fr)

rm -f cookies.txt
now=$(date +"%B %Y")
username="emailencoded"
password="***********"
carteID="000000"

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

urlLastPDF=$(curl -s "https://www.filbleu.fr/espace-perso/mes-cartes/$carteID" -b cookies.txt -c cookies.txt -H 'Host: www.filbleu.fr' -H 'User-Agent: Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:53.0) Gecko/20100
101 Firefox/53.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' -H 'Accept-Language: fr,fr-FR;q=0.8,en-US;q=0.5,en;q=0.3' --compressed -H 'Content-Type: application/x-www-form-urle
ncoded' -H 'Referer: https://www.filbleu.fr/espace-perso' -H 'DNT: 1' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'Pragma: no-cache' -H 'Cache-Control: no-cache' | grep ">01 $now</a>" | tr -
d '"' | grep -Po '<a href=\K([^>]+)')

curl -s "https://www.filbleu.fr/$urlLastPDF" -b cookies.txt -c cookies.txt -H 'Host: www.filbleu.fr' -H 'User-Agent: Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:53.0) Gecko/20100101 Firefox/53.0' -H 'Accept: text
/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' -H 'Accept-Language: fr,fr-FR;q=0.8,en-US;q=0.5,en;q=0.3' --compressed -H 'Content-Type: application/x-www-form-urlencoded' -H 'Referer: https://www.f
ilbleu.fr/espace-perso' -H 'DNT: 1' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'Pragma: no-cache' -H 'Cache-Control: no-cache' -o "Filbleu $now".pdf

echo "envoi du mail..."
echo "Attestation en piece jointe ;-)" | mutt -a "Filbleu $now".pdf -s "Attestation pour le mois de $now" -- email@domain.com
echo "suppression du la piece jointe"
rm "Filbleu $now".pdf
