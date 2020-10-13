#!/usr/bin/env perl6

use Sys::IP;
use Services::PortMapping;
use CheckSocket;

my $this-ip = Sys::IP.new.get_default_ip();

for <www-http ssh> -> $service {
    if check-socket(%TCPPorts{$service},$this-ip) {
        say "Your service $service is running in port %TCPPorts{$service}";
    } else {
        say "Apparently, your service $service is not running";
    }
}