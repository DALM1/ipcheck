#!/usr/bin/perl
use strict;
use warnings;
use Net::ARP;

# Fonction pour récupérer les adresses IP actives sur le même réseau
sub find_active_ips {
    my $interface = shift; # Interface réseau à utiliser
    my %active_ips;

   
    my $ip_and_mask = `ip addr show $interface | grep 'inet '`;
    my ($ip) = $ip_and_mask =~ /inet ([\d.]+)/;
    my ($mask) = $ip_and_mask =~ /\/(\d{1,2})/;

    # Calculer l'adresse IP du réseau
    my ($network) = $ip =~ /^(\d+\.\d+\.\d+)\.\d+$/;
    my $subnet = "$network.0";

   
    for my $i (1..254) {
        my $target_ip = "$subnet.$i";
        my $mac = Net::ARP::arp_mac($interface, $target_ip);
        if ($mac) {
            $active_ips{$target_ip} = $mac;
        }
    }

    return %active_ips;
}


my $interface = 'wlan0';  sous Linux


my %active_ips = find_active_ips($interface);


print "Adresses IP actives sur le même réseau Wi-Fi :\n";
foreach my $ip (keys %active_ips) {
    my $mac = $active_ips{$ip};
    print "IP: $ip, MAC: $mac\n";
}
