# 2026-08-02 13:44:15 by RouterOS 7.19.5
# software id = 8NHN-D98T
#
# model = C52iG-5HaxD2HaxD
# serial number = HK30AXAV3FB
/interface bridge
add admin-mac=04:F4:1C:7B:6B:6A auto-mac=no comment=defconf name=bridge
/interface wifi
set [ find default-name=wifi1 ] channel.band=5ghz-ax .skip-dfs-channels=\
    10min-cac .width=20/40/80mhz configuration.mode=ap .ssid=MikroTik-7B6B6E \
    security.authentication-types=wpa2-psk,wpa3-psk .ft=yes .ft-over-ds=yes
set [ find default-name=wifi2 ] channel.band=2ghz-ax .skip-dfs-channels=\
    10min-cac .width=20/40mhz configuration.mode=ap .ssid=MikroTik-7B6B6E \
    security.authentication-types=wpa2-psk,wpa3-psk .ft=yes .ft-over-ds=yes
/interface list
add comment=defconf name=WAN
add comment=defconf name=LAN
/ip hotspot profile
add dns-name=hotspot.local hotspot-address=192.168.1.1 name=hsprof1
/ip hotspot user profile
add mac-cookie-timeout=30s name=etudiant rate-limit=3M/8M session-timeout=5m \
    shared-users=2
add mac-cookie-timeout=30s name=invite rate-limit=512K/512K session-timeout=\
    3m
add mac-cookie-timeout=30s name=test rate-limit=10M/10M session-timeout=2m
/ip pool
add name=dhcp_pool3 ranges=192.168.1.10-192.168.1.254
/ip dhcp-server
add address-pool=dhcp_pool3 interface=bridge name=dhcp1
/ip hotspot
add address-pool=dhcp_pool3 disabled=no interface=bridge name=hotspot1 \
    profile=hsprof1
/certificate settings
set builtin-trust-anchors=not-trusted
/disk settings
set auto-media-interface=bridge auto-media-sharing=yes auto-smb-sharing=yes
/interface bridge port
add bridge=bridge comment=defconf interface=ether2
add bridge=bridge comment=defconf interface=ether3
add bridge=bridge comment=defconf interface=ether4
add bridge=bridge comment=defconf interface=ether5
add bridge=bridge comment=defconf interface=wifi1
add bridge=bridge comment=defconf interface=wifi2
/ip neighbor discovery-settings
set discover-interface-list=LAN
/interface list member
add comment=defconf interface=bridge list=LAN
add comment=defconf interface=ether1 list=WAN
/ip address
add address=192.168.1.1/24 interface=bridge network=192.168.1.0
/ip dhcp-client
# Interface not active
add comment=defconf interface=ether1
/ip dhcp-server network
add address=192.168.1.0/24 dns-server=192.168.1.1 gateway=192.168.1.1
/ip dns
set allow-remote-requests=yes max-concurrent-queries=2000 \
    max-concurrent-tcp-sessions=100 servers=8.8.8.8,1.1.1.1
/ip dns static
add address=192.168.1.1 name=router.lan type=A
/ip firewall filter
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
add action=accept chain=input connection-state=established,related
add action=drop chain=input connection-state=invalid
add action=accept chain=input in-interface=bridge
add action=drop chain=input
add action=accept chain=forward comment="FWD OK : reponses" connection-state=\
    established,related
add action=accept chain=forward comment="FWD OK : LAN vers WAN" in-interface=\
    bridge out-interface=ether1
add action=drop chain=forward comment="FWD BLOQUE : invalid" \
    connection-state=invalid
add action=drop chain=forward comment="FWD BLOQUE : reste"
/ip firewall nat
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
add action=masquerade chain=srcnat comment="nat wlan" out-interface=ether1
add action=masquerade chain=srcnat comment="masquerade hotspot network" \
    src-address=192.168.1.0/24
add action=masquerade chain=srcnat out-interface=ether1
add action=masquerade chain=srcnat out-interface=ether1
add action=masquerade chain=srcnat out-interface=ether1
/ip hotspot user
add name=admin profile=test
add name=vouffo profile=etudiant server=hotspot1
add name=mbogol profile=invite
add name=user1 profile=invite
add name=user2 profile=invite
add name=user3 profile=etudiant
add name=user8 profile=test server=hotspot1
/ip service
set www disabled=yes
/ipv6 firewall address-list
add address=::/128 comment="defconf: unspecified address" list=bad_ipv6
add address=::1/128 comment="defconf: lo" list=bad_ipv6
add address=fec0::/10 comment="defconf: site-local" list=bad_ipv6
add address=::ffff:0.0.0.0/96 comment="defconf: ipv4-mapped" list=bad_ipv6
add address=::/96 comment="defconf: ipv4 compat" list=bad_ipv6
add address=100::/64 comment="defconf: discard only " list=bad_ipv6
add address=2001:db8::/32 comment="defconf: documentation" list=bad_ipv6
add address=2001:10::/28 comment="defconf: ORCHID" list=bad_ipv6
add address=3ffe::/16 comment="defconf: 6bone" list=bad_ipv6
/ipv6 firewall filter
add action=accept chain=input comment=\
    "defconf: accept established,related,untracked" connection-state=\
    established,related,untracked
add action=drop chain=input comment="defconf: drop invalid" connection-state=\
    invalid
add action=accept chain=input comment="defconf: accept ICMPv6" protocol=\
    icmpv6
add action=accept chain=input comment="defconf: accept UDP traceroute" \
    dst-port=33434-33534 protocol=udp
add action=accept chain=input comment=\
    "defconf: accept DHCPv6-Client prefix delegation." dst-port=546 protocol=\
    udp src-address=fe80::/10
add action=accept chain=input comment="defconf: accept IKE" dst-port=500,4500 \
    protocol=udp
add action=accept chain=input comment="defconf: accept ipsec AH" protocol=\
    ipsec-ah
add action=accept chain=input comment="defconf: accept ipsec ESP" protocol=\
    ipsec-esp
add action=accept chain=input comment=\
    "defconf: accept all that matches ipsec policy" ipsec-policy=in,ipsec
add action=drop chain=input comment=\
    "defconf: drop everything else not coming from LAN" in-interface-list=\
    !LAN
add action=fasttrack-connection chain=forward comment="defconf: fasttrack6" \
    connection-state=established,related
add action=accept chain=forward comment=\
    "defconf: accept established,related,untracked" connection-state=\
    established,related,untracked
add action=drop chain=forward comment="defconf: drop invalid" \
    connection-state=invalid
add action=drop chain=forward comment=\
    "defconf: drop packets with bad src ipv6" src-address-list=bad_ipv6
add action=drop chain=forward comment=\
    "defconf: drop packets with bad dst ipv6" dst-address-list=bad_ipv6
add action=drop chain=forward comment="defconf: rfc4890 drop hop-limit=1" \
    hop-limit=equal:1 protocol=icmpv6
add action=accept chain=forward comment="defconf: accept ICMPv6" protocol=\
    icmpv6
add action=accept chain=forward comment="defconf: accept HIP" protocol=139
add action=accept chain=forward comment="defconf: accept IKE" dst-port=\
    500,4500 protocol=udp
add action=accept chain=forward comment="defconf: accept ipsec AH" protocol=\
    ipsec-ah
add action=accept chain=forward comment="defconf: accept ipsec ESP" protocol=\
    ipsec-esp
add action=accept chain=forward comment=\
    "defconf: accept all that matches ipsec policy" ipsec-policy=in,ipsec
add action=drop chain=forward comment=\
    "defconf: drop everything else not coming from LAN" in-interface-list=\
    !LAN
/radius
add address=192.168.1.1 service=hotspot
/radius incoming
set accept=yes
/system scheduler
add name=expire- on-event="/ip hotspot user disable " policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=2026-02-08 start-time=00:00:00
add interval=1d name=backup-quotidien on-event="\
    \n:local d [/system clock get date]\
    \n/system backup save name=(\"backup-\" . \$d)\
    \n/export file=(\"config-\" . \$d)\
    \n" policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon \
    start-date=2026-01-07 start-time=09:57:43
/system script
add dont-require-permissions=no name=collecte-stats owner=admin policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":\
    local d [/system clock get date]; :local h [/system clock get time]; :loca\
    l mois [:pick \$d 0 3]; :local annee [:pick \$d 7 11]; :local nEtu [/ip ho\
    tspot active print count-only where profile=\"etudiant\"]; :local nInv [/i\
    p hotspot active print count-only where profile=\"invite\"]; :local total \
    (\$nEtu + \$nInv); :local f (\"stats-\" . \$mois . \"-\" . \$annee . \".cs\
    v\"); :if ([:len [/file find name=\$f]] = 0) do={/file add name=\$f conten\
    ts=\"date,heure,etudiants,invites,total_connectes\\n\"}; :local c [/file g\
    et [find name=\$f] contents]; /file set [find name=\$f] contents=(\$c . \$\
    d . \",\" . \$h . \",\" . \$nEtu . \",\" . \$nInv . \",\" . \$total . \"\\\
    n\")"
/tool mac-server
set allowed-interface-list=LAN
/tool mac-server mac-winbox
set allowed-interface-list=LAN
