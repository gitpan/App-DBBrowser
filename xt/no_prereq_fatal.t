use 5.010001;
use warnings;
use strict;
use Test::More tests => 1;


my %prereqs_make;
open my $fh_m, '<', 'Makefile.PL' or die $!;
my $fatal = 0;
while ( my $line = <$fh_m> ) {
    if ( $line =~ /PREREQ_FATAL/i ) {
        $fatal++;
    }

}
close $fh_m or die $!;




is( $fatal, 0, 'OK - NO PREREQ_FATAL in Makefile.PL' );
