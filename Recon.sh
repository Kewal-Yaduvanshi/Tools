#!/bin/bash

#Author: Kewal
#Recon Script


SubdomainEnum(){

echo "Enter Domain"
read DOMAIN

VAR1=${DOMAIN#*//}
DOMAIN_NAME=${VAR1%.com}


 subfinder -d $DOMAIN -o subfinder.txt
 assetfinder -subs-only $DOMAIN | tee assetfinder.txt
 subscraper $DOMAIN --censys-id 113862de-dd0e-47d0-9424-2b08390c93fb --censys-secret cy2XoSEOwj5dyqZoqgECDZUWt85Lyuhk -r censys_subs.txt
 github-subdomains -d $DOMAIN -t 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 -o subs2.txt  

 cat assetfinder.txt | anew subfinder.txt
 cat subfinder.txt | anew censys_subs.txt
 cat censys_subs.txt | anew subs2.txt 
 mv subs2.txt subd.txt

 Probe

}


Probe(){

cat subd.txt | httpx | tee commonprobe.txt
cat subd.txt | httprobe -p http:81 -p http:8008 -p https:8008 -p https:3001 -p http:8000 -p https:8000 -p http:8080 -p https:8080 -p https:8443 -p https:10000 -p - -c 100 | tee uncommon_probe.txt

cat commonprobe.txt | anew uncommon_probe.txt
mv uncommon_probe.txt Finallist.txt 
rm assetfinder.txt commonprobe.txt subfinder.txt censys_subs.txt  

Paramenum

}

Paramenum(){


  
echo "PARAM ENUM STARTED"


arjun -i Finallist.txt  -t 100 --passive | tee arjun_${DOMAIN_NAME}.txt

RemoveDuplicate

}

RemoveDuplicate() {

cat arjun_${DOMAIN_NAME}.txt | uro > Final_Paramlist_${DOMAIN_NAME}.txt
rm arjun_${DOMAIN_NAME}.txt

}


SubdomainEnum
