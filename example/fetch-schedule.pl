#!/usr/bin/perl -w

use DateTime;
use WebService::OCTranspo;

my $stop  = shift or die q{stop number};
my $route = shift or die q{route number};
my $date  = DateTime->now();

my $oc = WebService::OCTranspo->new();

my $s  = $oc->schedule_for({
	stop_id  => $stop,
	route_id => $route,
	date     => $date,
});

print 
	join("\n", @{ $s->{times} } ),
	"\n",
	join("\n", @{ $s->{notes} } ),
	"\n";
