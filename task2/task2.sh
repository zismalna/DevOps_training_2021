#!bin/bash
apt-get update && apt-get -y upgrade
apt-get install -y nginx
opsys=$(uname -a)
indexpage=/var/www/html/index.nginx-debian.html
echo -e '<!DOCTYPE html>\n<html>\n<head>\n<title>Welcome to nginx!</title>\n<style>\nbody {\nwidth: 35em;\nmargin: 0 auto;\nfont-family: Tahoma, Verdana, Arial, sans-serif;\n    }\n</style>\n</head>\n<body>\n<h1>Hello world!</h1>' > $indexpage
echo "$opsys" >> $indexpage
echo -e '</body>\n</html>' >> $indexpage

