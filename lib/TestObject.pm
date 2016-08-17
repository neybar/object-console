package TestObject;

use Moo;
use Types::Standard qw(Any Int);

has foo => (
    is  => 'rw',
    isa => Int,
);

has bar => (
    is  => 'rw',
    isa => Any,
);

1;
