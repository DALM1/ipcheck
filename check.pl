#!/usr/bin/perl
use strict;
use warnings;
use Net::ARP;


sub find_active_ips {
    my $interface = shift; 
    my %active_ips;


    my $ip = `ifconfig $interface | grep 'inet ' | awk '{print \$2}'`;
    chomp($ip);

   
    my ($network) = $ip =~ /^(\d+\.\d+\.\d+)\.\d+$/;
    my $subnet = "$network.0";

    
    for my $i (1..254) {
        my $target_ip = "$subnet.$i";
        my $mac = Net::ARP::arp_mac($target_ip);
        if ($mac) {
            $active_ips{$target_ip} = $mac;
        }
    }

    return %active_ips;
}


my $interface = 'en0'; 


my %active_ips = find_active_ips($interface);


print "Adresses IP actives sur le même réseau Wi-Fi :\n";
foreach my $ip (keys %active_ips) {
    my $mac = $active_ips{$ip};
    print "IP: $ip, MAC: $mac\n";
}
