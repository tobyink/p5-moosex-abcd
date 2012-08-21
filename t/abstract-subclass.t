#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use Test::Fatal;

{
    package Foo;
    use Moose;
    use MooseX::ABCD;

    requires 'foo';
    requires 'bar';
    __PACKAGE__->meta->make_immutable;
}

{
    package Foo::Sub;
    use Moose;
    use MooseX::ABCD;
    extends 'Foo';

    requires 'baz';

    sub bar { 'BAR' }
    __PACKAGE__->meta->make_immutable;
}

{
    package Foo::Sub::Sub;
    use Moose;
    extends 'Foo::Sub';

    sub foo { 'FOO' }
    sub baz { 'BAZ' }
    __PACKAGE__->meta->make_immutable;
}

like(
    exception { Foo->new },
    qr/Foo is abstract, it cannot be instantiated/,
    "can't create Foo objects"
);
like(
    exception { Foo::Sub->new },
    qr/Foo::Sub is abstract, it cannot be instantiated/,
    "can't create Foo::Sub objects"
);

my $foo = Foo::Sub::Sub->new;
is($foo->foo, 'FOO', 'successfully created a Foo::Sub::Sub object');

done_testing;
