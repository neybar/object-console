package Commands;

use Moo;
use Try::Tiny;
use Data::Debug qw(debug debug_text);
use v5.24.0;

has 'object' => (
    is       => 'rw',
    required => 1,
);

sub skel {
    my ($self, $string) = @_;
    # your command will get a string.  It is your job to parse the string to do something useful

    return "$string to show user";
}


sub get {
    my ($self, $key) = @_;
    # not going to check $key.  If you pass in garbage then the object won't get updated

    my $value;
    try {
        if ($key eq '*') {
            $value = debug_text($self->object);
        } else {
            # this is naïve... assuming a Moo/Moose type of object
            $value = $self->object->$key;
        }
    } catch {
        # couldn't get the key, show the error to the user.
        $_;
    };
    return "value ($key): '$value'";
}

sub set {
    my ($self, $stuff) = @_;
    $stuff =~ m/(\w*)\s*=\s*(.*)$/;
    my $key   = $1;
    my $value = $2;

    my $rv = try {
        # this is naïve... assuming a Moo/Moose type of object
        $self->object->$key($value);
    } catch {
        # something didn't work.  Maybe a constraint failed.  Show the error to the user.
        $_;
    };
    return $rv;
}

1;
