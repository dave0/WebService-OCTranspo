#!/usr/bin/perl -w

use WWW::Mechanize;
use HTML::Form::ForceValue;
use HTML::TableExtract;
use DateTime;
use Data::Dumper;

use constant DEBUG => 1;

my $stop = shift or die q{stop number};
my $route = shift or die q{route number};
my $date = DateTime->now();

my $mech = WWW::Mechanize->new(
	cookie_jar => {}
);
$mech->agent_alias( 'Windows IE 6' );

# First, get the form page
warn "Fetching start page for new session" if DEBUG;
$mech->get('http://www.octranspo.com/tps/jnot/sptStartEN.oci');

# Select the form
warn "Selecting form via mech" if DEBUG;
$mech->form_name('spt_date');

warn "Forcing form values" if DEBUG;
# Force some values.  Yes, all this duplication is necessary.
warn $mech->current_form->dump;
$mech->current_form()->force_value('theDate',     $date->ymd);
$mech->current_form()->force_value('travelDate',  $date->ymd);
$mech->current_form()->force_value('visibleDate', $date->month_name . ' ' . $date->day);
$mech->current_form()->force_value('theTime',     '0000');

warn "Submitting date form" if DEBUG;
$mech->click();

# Select a stop number
warn "Selecting stop form" if DEBUG;
$mech->form_name('spt_choose560');
$mech->current_form->force_value('the560number', $stop);
warn "Submitting stop form" if DEBUG;
$mech->click();

# Confirm the stop
warn "Selecting stop confirm form" if DEBUG;
$mech->form_name('spt_confirm560');
warn "Submitting stop confirm form" if DEBUG;
$mech->click();

# ARGH! this works for one-route stops, but not for multi-route stops.
# Need to parse the output and:
# a) if it's asking for a route number, find the one we want and select
# the appropriate checkbox
# b) if it's not, parse the output for the stop data
warn "Looking for $route";
if( my ($checkname) = $mech->content =~ m{<label for="(check\d+)">$route}o ) {
	warn "Got checkbox name $checkname";
	$mech->form_name('spt_selectRoutes');
	$mech->current_form()->force_value($checkname, 1);
	$mech->click();
}

my $te = HTML::TableExtract->new( attribs => { class => 'spt_table' } );
$te->parse( $mech->content );

my @times;
foreach $ts ( $te->tables ) {
	print "Table (", join(',', $ts->coords), "):\n";
	foreach $row ( $ts->rows ) {
		foreach my $cell ( @$row ) {
			next if ! defined $cell;
			$cell =~ s/^\s+//s;
			$cell =~ s/\s+$//s;
			$cell =~ s/\s+/ /gs;
			if( $cell =~ m/^\d+:\d+/ ) {
				push @times, $cell;
			}
		}
	}
}

my @notes;
$te = HTML::TableExtract->new( headers => [ 'Stop Note Information' ] );
$te->parse( $mech->content );

foreach my $row ($te->rows) {
	push @notes, $row->[0];
}

print Dumper \@times, \@notes;
