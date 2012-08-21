package MooseX::ABCD;

BEGIN {
	$MooseX::ABCD::AUTHORITY = 'cpan:TOBYINK';
	$MooseX::ABCD::VERSION   = '0.001';
}

use 5.008;
use Moose 2.00 ();
use MooseX::ABC 0.06 ();
use Moose::Exporter;

sub requires
{
	shift->add_required_method(@_);
}
 
Moose::Exporter->setup_import_methods(
	with_meta => [qw(requires)],
);
 
sub init_meta
{
	my ($package, %options) = @_;

	Carp::confess("Can't make a role into an abstract base class")
		if Class::MOP::class_of($options{for_class})->isa('Moose::Meta::Role');

	Moose::Util::MetaRole::apply_metaroles(
		for             => $options{for_class},
		class_metaroles => { class => ['MooseX::ABCD::Trait::Class'] },
	);
	Moose::Util::MetaRole::apply_base_class_roles(
		for   => $options{for_class},
		roles => ['MooseX::ABC::Role::Object'],
	);

	Class::MOP::class_of($options{for_class})->is_abstract(1);
	return Class::MOP::class_of($options{for_class});
}
  
1;

__END__

=head1 NAME

MooseX::ABCD - MooseX::ABC, but checking required methods on make_immutable

=head1 SYNOPSIS

	{
		package Shape;
		use Moose;
		use MooseX::ABCD;
		requires 'draw';
		__PACKAGE__->meta->make_immutable;
	}
	
	{
		package Circle;
		use Moose;
		extends 'Shape';
		sub draw {
			...;
		}
		__PACKAGE__->meta->make_immutable;
	}
	
	my $shape  = Shape->new;   # dies
	my $circle = Circle->new;  # succeeds
	
	{
		package Square;
		use Moose;
		extends 'Shape';
		__PACKAGE__->meta->make_immutable;
		# ^^^ dies, draw is unimplemented
	}

=head1 DESCRIPTION

What does ABCD stand for? Hmmm... maybe "abstract base classes deferred"?
or "abstract base classes declare-compatible"? (This module works with
MooseX::Declare, whereas MooseX::ABC does not!)

Anyway, whatever ABCD does or does not stand for, this is what MooseX::ABCD
does: it works just like MooseX::ABC, the checks that derived classes
implement all abstract methods happen when the class is made immutable,
not when inheritance is set up.

Why? It works better with MooseX::Declare this way.

=head2 Functions

This module exports one function to your namespace:

=over

=item C<requires>

Works like C<requires> in Moose roles, but for classes.

=back

=begin private

=item C<init_meta> 

=end private

=head1 BUGS

Please report any bugs to
L<http://rt.cpan.org/Dist/Display.html?Queue=MooseX-ABCD>.

=head1 SEE ALSO

L<MooseX::ABC>, L<MooseX::AbstractMethod>.

=head1 AUTHOR

Toby Inkster E<lt>tobyink@cpan.orgE<gt>, though most of the code is stolen
from Jesse Luehrs. (But don't blame him is something goes wrong. For that
matter, don't blame me either - take a look at the disclaimer of warranties.)

=head1 COPYRIGHT AND LICENCE

This software is copyright (c) 2012 by Toby Inkster.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=head1 DISCLAIMER OF WARRANTIES

THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.

