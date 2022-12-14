#!/bin/sh
#
# (c) 2016 Francesco Colista
# fcolista@alpinelinux.org
#
# Configure metasploit to run as $USER
#
echo "*** METASPLOIT INSTALL FOR ALPINE LINUX ***"
echo 
echo "==> Account configuration."
export USER="msfuser"
adduser $USER
echo 
echo "The user $USER will be automatically added among sudoers with all permissions"
echo
echo "$USER	ALL=(ALL:ALL) ALL" >> /etc/sudoers

apk update && apk upgrade
apk add --progress alpine-sdk ruby-dev libffi-dev\
	openssl-dev readline-dev sqlite-dev \
	autoconf bison libxml2-dev postgresql-dev \
	libpcap-dev yaml-dev subversion git sqlite ruby-webrobots \
	ruby-bundler zlib-dev ruby-io-console ruby-nokogiri \
	ruby-activesupport4.2 ruby-activerecord4.2 ruby-bigdecimal \
	ncurses ncurses-dev nmap

gem install --no-rdoc --no-ri wirble sqlite3 bundler

mkdir -p /opt && cd /opt

git clone https://github.com/rapid7/metasploit-framework.git

cd metasploit-framework

cat - <<-EOF | su $USER
mkdir /home/$USER/.msf4
mkdir /home/$USER/.bundle
bundle install
EOF

for MSF in $(ls msf*); do 
	if ! [ -L /usr/local/bin/$MSF ]; then
		ln -s /opt/metasploit-framework/$MSF /usr/local/bin/$MSF;
	fi
done

echo " ==> Database configuration "
echo
export DBUSER="msfdbuser"
export DBPASS="dbpass"
export DBNAME="msf"

echo "Those are the settings you choosed: "
echo "DBUser: $DBUSER"
echo "DBPass: $DBPASS"
echo "DBName: $DBNAME"

# Configuration
/etc/init.d/postgresql setup
/etc/init.d/postgresql start

psql -U postgres -c "CREATE USER $DBUSER WITH PASSWORD '"$DBPASS"' ;"
psql -U postgres -c "CREATE DATABASE $DBNAME OWNER $DBUSER;"
psql -U postgres -c "grant ALL ON DATABASE $DBNAME TO $DBUSER;"

# Workaround stated in http://stackoverflow.com/questions/25392268/cant-load-metasplot-after-istallation
chmod o+r /usr/lib/ruby/gems/2.2.0/gems/robots-0.10.1/lib/robots.rb

cat<<'EOF'>/home/$USER/.msf4/database.yml
production:
 adapter: postgresql
 database: $DBNAME
 username: $DBUSER
 password: $DBPASS
 host: 127.0.0.1
 port: 5432
 pool: 75
 timeout: 5
EOF

cat - <<-EOF | su $USER
msfconsole -x "db_connect $DBUSER:$DBPASS@127.0.0.1:5432/$DBNAME"
msfconsole -x "db_status"
EOF
