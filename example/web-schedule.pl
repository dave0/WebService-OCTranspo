#!/usr/bin/perl -w
use strict;
use warnings;
use DateTime;
use WebService::OCTranspo;
use XML::Simple;
use Cache::File;
use Storable qw( freeze thaw );
use CGI qw( :cgi );

my $q = CGI->new();

my ($stop, $route) = $q->path_info =~ m{/stop/(\d+)/route/(\d+)};

print "Content-type: text/plain\n\n";

unless( $route && $stop ) {
	print "Must supply a valid route _AND_ stop ID\n";
	exit;
}

my $type = $q->param('type') || 'today';

my $c = Cache::File->new( 
	cache_root      => '/tmp/webservice-octranspo',
	default_expires => '1800 sec',
);

my $key = "$type:$route:$stop";

if( ! $c->exists( $key ) ) {

	my $date  = DateTime->now();

	# Force Ottawa-local timezone before doing date math
	$date->set_time_zone('America/Toronto');

	# Get next day matching the type
	# TODO: allow user specification of exact date?
	if( $type eq 'weekday' ) {
		while( $date->day_of_week >= 5 ) {
			$date->add( days => 1 );
		}
	} elsif ($type eq 'weekend') {
		while( $date->day_of_week < 5 ) {
			$date->add( days => 1 );
		}
	} else {
		# Today, specifically.  Don't mess with the date.
	}

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

	$s->{type} = $type;

	$s->{date} = '' .$s->{date};  # Force stringification to keep XMLout happy

	$c->set( $key, freeze $s );
}

my $sched = $c->get( $key );

if( ! $sched ) {
	print "No schedule for that stop\n";
	exit;
}

my $s = thaw( $sched );

# Munge key names so we produce <notes><note>...</><note>...</></notes>
$s->{notes} = [ map {+{ id => $_, content => $s->{notes}{$_} }} keys %{$s->{notes}} ];

print XMLout( $s, 
	NoAttr => 1,
	RootName => 'schedule',

	GroupTags => {
		times => 'time'
	},

	KeyAttr => {
		notes => 'id',	
	},
);
