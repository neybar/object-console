#! /usr/bin/env perl

use strict;
use warnings;
use v5.24.0;

use lib qw(lib);
use IO::Prompter;
use Commands;

my $object = $ARGV[0];
# quick and dirty...
eval "require $object";
my $o = $object->new();

my $commands = Commands->new( object => $o );
while (prompt -stdio, "ctrl-c to quit\n> ") {
    # Started with a regex, but decided to let the method deal with parsing
    # $_ =~ m{
    #     ^                      # beginning
    #     \s*                    # extra spaces
    #     (?<command>\w*)        # find the $command
    #     (?:                    # optional $key
    #         \s+                # extra spaces
    #         (?<key>[\w\*]*)    # $key or *
    #         (?:                # optional $value
    #             \s*            # extra spaces
    #             =              # yep...
    #             \s*            # extra spaces
    #             (?<value>.*)   # whatever is left.  
    #         )*
    #     )*
    # }xsm;
    # my $command = lc $+{'command'};
    # my $key     = $+{'key'};
    # my $value   = $+{'value'};

    $_ =~ m{^\s*(\w*)\s*(.*)$};
    my $command = $1;
    my $rest    = $2;
    chomp $rest if $rest;

    if (my $meth = $commands->can($command)) {
        say eval { $meth->($commands, $rest) } || "Something bad happened: $@";
    } else {
        say "Command ($command) not found";
    }
}
