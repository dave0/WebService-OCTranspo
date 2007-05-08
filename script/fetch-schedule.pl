#!/usr/bin/perl -w

use DateTime;
use Data::Dumper;
my $stop = shift or die q{stop number};
my $route = shift or die q{route number};
my $date = DateTime->now();

my $oc = WebService::OCTranspo::StopSchedules->new();

my $s  = $oc->schedule_for({
	stop_id  => $stop,
	route_id => $route,
	date     => $date,
});

print join("\n", @{ $s->{times} } );
print "\n";
print join("\n", @{ $s->{notes} } );

package WebService::OCTranspo::StopSchedules;
use WWW::Mechanize;
use HTML::Form::ForceValue;
use HTML::TableExtract;
use Carp;

our $VERSION = '0.010';

use constant DEBUG => 0;


sub new
{
	my ($class) = @_;
	my $self = {};
	$self->{mech} = WWW::Mechanize->new(
		cookie_jar => {},
		agent      => 'WebService-OCTranspo/' . $VERSION,
	);

	bless $self => $class;
	return $self;
}

sub schedule_for
{
	my( $self, $args ) = @_;

	foreach my $key ( qw( stop_id route_id date) ) {
		if( ! exists $args->{$key} ) {
			croak qq{$key argument required for schedule_for()};
		}
	}

	$self->_reset();
	$self->_select_date( $args->{date} );
	$self->_select_stop( $args->{stop_id} );
	$self->_select_route( $args->{route_id} );
	
	return $self->_parse_schedule();
}

sub _reset
{
	my ($self) = @_;
	# First, get the form page
	warn "Fetching start page for new session" if DEBUG;
	$self->{mech}->get('http://www.octranspo.com/tps/jnot/sptStartEN.oci');
}

sub _select_date
{
	my ($self, $date) = @_;
	# Select the form
	warn "Selecting form via mech" if DEBUG;
	$self->{mech}->form_name('spt_date');
	warn $self->{mech}->current_form->dump if DEBUG;

	my $form = $self->{mech}->current_form();

	# Disable 'readonly' attribute
	$form->find_input( 'travelDate' )->readonly(0);
	$form->find_input( 'visibleDate' )->readonly(0);

	warn "Forcing form values" if DEBUG;
	# Force some values.  Yes, all this duplication is necessary.
	$form->force_value('theDate',     $date->ymd);
	$form->force_value('travelDate',  $date->ymd);
	$form->force_value('visibleDate', $date->month_name . ' ' . $date->day);
	$form->force_value('theTime',     '0000');

	warn "Submitting date form" if DEBUG;
	$self->{mech}->click();
}

sub _select_stop
{
	my ($self, $stop_id) = @_;
	# Select a stop number
	warn "Selecting stop form" if DEBUG;
	$self->{mech}->form_name('spt_choose560');
	warn $self->{mech}->current_form->dump if DEBUG;
	$self->{mech}->current_form->force_value('the560number', $stop_id);
	warn "Submitting stop form" if DEBUG;
	$self->{mech}->click();

	# Confirm the stop
	warn "Selecting stop confirm form" if DEBUG;
	$self->{mech}->form_name('spt_confirm560');
	warn $self->{mech}->current_form->dump if DEBUG;
	warn "Submitting stop confirm form" if DEBUG;
	$self->{mech}->click();
}

sub _select_route
{
	my ($self, $route_id) = @_;
	# By now we may have data for one-route stops, but not for
	# multi-route stops.  
	# Need to parse the output and:
	# a) if it's asking for a route number, find the one we want and select
	# the appropriate checkbox
	# b) if it's not, parse the output for the stop data
	warn "Looking for $route_id" if DEBUG;
	if( my ($checkname) = $self->{mech}->content =~ m{<label for="(check\d+)">$route_id}o ) {
		warn "Got checkbox name $checkname" if DEBUG;
		$self->{mech}->form_name('spt_selectRoutes');
		warn $self->{mech}->current_form->dump if DEBUG;
		$self->{mech}->current_form()->force_value($checkname, 1);
		$self->{mech}->click();
	}
}

sub _parse_schedule
{
	my ($self) = @_;

	my %schedule = (
		'times' => [],
		'notes' => [],
	);

	my $te = HTML::TableExtract->new( attribs => { class => 'spt_table' } );
	$te->parse( $self->{mech}->content );

	foreach $ts ( $te->tables ) {
		print "Table (", join(',', $ts->coords), "):\n";
		foreach $row ( $ts->rows ) {
			foreach my $cell ( @$row ) {
				next if ! defined $cell;
				$cell =~ s/^\s+//s;
				$cell =~ s/\s+$//s;
				$cell =~ s/\s+/ /gs;
				if( $cell =~ m/^\d+:\d+/ ) {
					push @{$schedule{'times'}}, $cell;
				}
			}
		}
	}

	$te = HTML::TableExtract->new( headers => [ 'Stop Note Information' ] );
	$te->parse( $self->{mech}->content );

	foreach my $row ($te->rows) {
		push @{$schedule{'notes'}}, $row->[0];
	}

	return \%schedule;
}
