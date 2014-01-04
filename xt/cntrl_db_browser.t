use 5.010001;
use strict;
use warnings;
use File::Basename qw(basename);
use Test::More tests => 2;


my $file = 'bin/db-browser';

my $data_dumper = 0;
my $warnings    = 0;

open my $fh, '<', $file or die $!;
while ( my $line = readline $fh ) {
    if ( $line =~ /^\s*use\s+Data::Dumper/s ) {
        $data_dumper++;
    }
    if ( $line =~ /^\s*use\s+warnings/s ) {
        $warnings++;
    }
}
close $fh;

is( $data_dumper, 0, 'OK - Data::Dumper in "' . basename( $file ) . '" disabled.' );
is( $warnings,    0, 'OK - warnings in "'     . basename( $file ) . '" disabled.' );
