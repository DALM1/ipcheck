#!/usr/bin/perl
use strict;
use warnings;

sub find_active_ips {
    my $interface = shift;
    my %active_ips;

    my @arp_output = `arp -a -i $interface`;

    foreach my $line (@arp_output) {
        if ($line =~ /\((\d+\.\d+\.\d+\.\d+)\) at ([0-9a-f:]+)/i) {
            my ($ip, $mac) = ($1, $2);
            $active_ips{$ip} = $mac;
        }
    }

    return %active_ips;
}

my $interface = 'en0';

my %active_ips = find_active_ips($interface);

print "Adresses IP actives sur le réseau $interface :\n";
foreach my $ip (keys %active_ips) {
    my $mac = $active_ips{$ip};
    print "IP: $ip, MAC: $mac\n";
}
