#!/bin/bash

ZONE="test2.test"

mkdir -p "/etc/bind/named.conf.d/"

echo -e "zone \"$ZONE\" {\n  type master;\n  file \"/var/lib/bind/$ZONE.db\";\n  allow-update { key \"pc.$ZONE.\"; }; \n};" > "/etc/bind/named.conf.d/$ZONE.conf"

cat >"/var/lib/bind/$ZONE.db" <<END
\$ORIGIN .
\$TTL 3600      ; 1 hour
$ZONE           IN SOA  ns1.$ZONE. root.$ZONE. (
                                2007010402 ; serial
                                3600       ; refresh (1 hour)
                                600        ; retry (10 minutes)
                                86400      ; expire (1 day)
                                600        ; minimum (10 minutes)
                                )
                        NS      ns1.$ZONE.
\$ORIGIN $ZONE.
ns1                     A       192.168.0.1
END

echo "" > "/etc/bind/named.conf.dir"
for f in /etc/bind/named.conf.d/*.conf
do
  echo "include \"$f\";" >> "/etc/bind/named.conf.dir"
done

systemctl reload bind9

