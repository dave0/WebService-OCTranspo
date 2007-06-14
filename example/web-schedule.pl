#!/usr/bin/perl -w
use strict;
use warnings;
use DateTime;
use WebService::OCTranspo;
use YAML ();

my $path = $ENV{PATH_INFO};

my ($stop, $route) = $path =~ m{/stop/(\d+)/route/(\d+)};

my $date  = DateTime->now();

print "Content-type: text/plain\n\n";

unless( $route && $stop ) {
	print "Must supply a valid route _AND_ stop ID\n";
	exit;
}

# TODO: caching of data
# TODO: differentiate weekday/weekend schedules for caching purposes
# TODO: allow user specification of date?

my $oc = WebService::OCTranspo->new();

my $s = eval {
	$oc->schedule_for_stop({
		stop_id  => $stop,
		route_id => $route,
		date     => $date,
	});
};
if( $@ ) {
	my $err = $@;
	$err =~ s/ at \/.*$//;
	print $err;
	exit;
}

print YAML::Dump $s;
