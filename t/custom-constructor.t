#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

our $custom_constructor_called = 0;

{
    package Foo;
    use Moose;
    use MooseX::ABCD;

    requires 'bar', 'baz';
    __PACKAGE__->meta->make_immutable;
}

{
    package Foo::Sub;
    use Moose;
    extends 'Foo';

    sub bar { }
    sub baz { }
    sub new { $::custom_constructor_called++; shift->SUPER::new(@_) }
    __PACKAGE__->meta->make_immutable;
}

my $foosub = Foo::Sub->new;
ok($custom_constructor_called, 'custom constructor was called');

done_testing;
