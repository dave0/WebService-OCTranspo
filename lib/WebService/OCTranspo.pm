package WebService::OCTranspo;
use strict;
use warnings;

use WWW::Mechanize;
use HTML::Form::ForceValue;
use HTML::TableExtract;

use Carp;

our $VERSION = '0.011';

my $DEBUG = 0;
sub DEBUG { $DEBUG };

sub new
{
	my ($class, $args) = @_;

	if( $args->{debug} ) {
		$DEBUG = $args->{debug};
	}

	my $self = {};
	$self->{mech} = WWW::Mechanize->new(
		cookie_jar => {},
		agent      => 'WebService-OCTranspo/' . $VERSION,
	);

	bless $self, $class;
	return $self;
}

sub schedule_for_stop
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
	warn 'Fetching start page for new session' if DEBUG;

	# More evil.  Their broken HTML has an <input type='input' ...>
	# which is completely invalid.  So... catch the warning
	local $SIG{__WARN__} = sub {
		warn $_[0] unless $_[0] =~ m/^Unknown input type 'input' at/;
	};

	$self->{mech}->get('http://www.octranspo.com/tps/jnot/sptStartEN.oci');
}

sub _select_date
{
	my ($self, $date) = @_;
	# Select the form
	warn 'Selecting form via mech' if DEBUG;
	$self->{mech}->form_name('spt_date');
	warn $self->{mech}->current_form->dump if DEBUG;

	my $form = $self->{mech}->current_form();

	# Disable 'readonly' attribute
	$form->find_input( 'travelDate' )->readonly(0);
	$form->find_input( 'visibleDate' )->readonly(0);

	warn 'Forcing form values' if DEBUG;
	# Force some values.  Yes, all this duplication is necessary.
	$form->force_value('theDate',     $date->ymd);
	$form->force_value('travelDate',  $date->ymd);
	$form->force_value('visibleDate', $date->month_name . ' ' . $date->day);
	$form->force_value('theTime',     '0000');

	warn 'Submitting date form' if DEBUG;
	$self->{mech}->click();
}

sub _select_stop
{
	my ($self, $stop_id) = @_;
	# Select a stop number
	warn 'Selecting stop form' if DEBUG;
	$self->{mech}->form_name('spt_choose560');
	warn $self->{mech}->current_form->dump if DEBUG;
	$self->{mech}->current_form->force_value('the560number', $stop_id);
	warn 'Submitting stop form' if DEBUG;
	$self->{mech}->click();

	# Confirm the stop
	warn 'Selecting stop confirm form' if DEBUG;
	$self->{mech}->form_name('spt_confirm560');
	warn $self->{mech}->current_form->dump if DEBUG;
	warn 'Submitting stop confirm form' if DEBUG;
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

	warn $self->{mech}->content if DEBUG;

	my $te = HTML::TableExtract->new( attribs => { class => 'spt_table' } );
	$te->parse( $self->{mech}->content );

	foreach my $ts ( $te->tables ) {
		warn 'Table (', join(q{,}, $ts->coords), '):' if DEBUG;
		foreach my $row ( $ts->rows ) {
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

	warn "Now looking for stop note info" if DEBUG;

	$te = HTML::TableExtract->new( headers => [ 'Stop Note Information' ] );
	$te->parse( $self->{mech}->content ) ;

	if( $te->tables ) { 
		foreach my $row ($te->rows) {
			push @{$schedule{'notes'}}, $row->[0];
		}
	}

	return \%schedule;
}

1;
__END__

=head1 NAME
 
WebService::OCTranspo - Access schedule information from www.octranspo.com
 
=head1 SYNOPSIS
 
    use WebService::OCTranspo;
    # Brief but working code example(s) here showing the most common usage(s)
 
    # This section will be as far as many users bother reading
    # so make it as educational and exemplary as possible.
  
=head1 DESCRIPTION
 
This module provides access to some of the bus schedule information
available from OCTranspo -- the public transit service in Ottawa,
Ontario, Canada.
 
=head1 METHODS

=head2 new ( ) 

Creates a new WebService::OCTranspo object

=head2 schedule_for_stop ( $args )

Fetch schedule for a single route at a single stop.  Returns a
WebService::OCTranspo::Schedule object for the route.  

B<$args> must be a hash reference containing all of:

=over 4

=item stop_id

The numeric ID of the bus stop.  This should be the "560 Code"
displayed at each stop, usually used for retrieving the bus stop
information by phone.

=item route_id

The bus route number.  Use integers only -- 'X' routes should omit the
X suffix.

=item date

A DateTime object

=back
 
=head1 DIAGNOSTICS
 
A list of every error and warning message that the module can generate
(even the ones that will "never happen"), with a full explanation of
each problem, one or more likely causes, and any suggested remedies.
 
=head1 CONFIGURATION AND ENVIRONMENT

A full explanation of any configuration system(s) used by the module,
including the names and locations of any configuration files, and the
meaning of any environment variables or properties that can be set.
These descriptions must also include details of any configuration
language used.
 
=head1 DEPENDENCIES

A list of all the other modules that this module relies upon, including
any restrictions on versions, and an indication whether these required
modules are part of the standard Perl distribution, part of the
module's distribution, or must be installed separately.

=head1 INCOMPATIBILITIES

A list of any modules that this module cannot be used in conjunction
with.  This may be due to name conflicts in the interface, or
competition for system or program resources, or due to internal
limitations of Perl (for example, many modules that use source code
filters are mutually incompatible).

There are no known incompatibilities with this module.
 
=head1 BUGS AND LIMITATIONS
 
There are no known bugs in this module. 
Please report problems to the author.
Patches are welcome.
 
=head1 AUTHOR
 
Dave O'Neill (dmo@dmo.ca)
 
=head1 LICENCE AND COPYRIGHT

Copyright (C) 2007 Dave O'Neill

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.
