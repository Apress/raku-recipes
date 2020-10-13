#!/usr/bin/env perl6


use Sys::Lastlog;

say .user.username, ", ", .entry.timestamp for Sys::Lastlog.new().list.grep: *.entry.time > 0;



