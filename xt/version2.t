use 5.010001;
use strict;
use warnings;

use File::Basename qw(basename);
use Time::Piece;
use Test::More tests => 6;


my $v_changes    = -1;
my $v_lib        = -1;
my $v_lib_pod    = -1;
my $v_bin        = -1;
my $v_db         = -1;
my $v_bin_pod    = -1;
my $release_date = -1;


my $lib = 'lib/App/DBBrowser.pm';
open my $fh1, '<', $lib or die $!;
while ( my $line = <$fh1> ) {
    if ( $line =~ /^our\ \$VERSION\ =\ '(\d+\.\d\d\d)';/ ) {
        $v_lib = $1;
    }
    if ( $line =~ /\A=pod/ .. $line =~ /\A=cut/ ) {
        if ( $line =~ /^\s*Version\s+(\S+)/ ) {
            $v_lib_pod = $1;
        }
    }
}
close $fh1;


my $bin = 'bin/db-browser';
open my $fh2, '<', $bin or die $!;
my $count;
while ( my $line = <$fh2> ) {
    if ( $line =~ /^our\ \$VERSION\ =\ '(\d+\.\d\d\d)';/ ) {
        $count++;
        if ( $count == 1 ) {
            $v_bin = $1;
        }
        else {
            $v_db = $1;
        }
    }
    if ( $line =~ /^=pod/ .. $line =~ /\A=cut/ ) {
        if ( $line =~ /^\s*Version\s+(\S+)/ ) {
            $v_bin_pod = $1;
        }
    }
}
close $fh2;


open my $fh_ch, '<', 'Changes' or die $!;
while ( my $line = <$fh_ch> ) {
    if ( $line =~ /^\s*(\d+\.\d\d\d)\s+(\d\d\d\d-\d\d-\d\d)\s*\Z/ ) {
        $v_changes = $1;
        $release_date = $2;
        last;
    }
}
close $fh_ch;


my $t = localtime;
my $today = $t->ymd;


is( $v_lib,        $v_changes, 'Version in "Changes" OK' );
is( $v_lib,        $v_lib_pod, 'Version in "' . basename( $lib ) . '" POD OK' );
is( $v_lib,        $v_bin,     'Version in "' . basename( $bin ) . '" OK'     );
is( $v_lib,        $v_db,      'Version in "App::DBBrowser::DB" OK');
is( $v_lib,        $v_bin_pod, 'Version in "' . basename( $bin ) . '" POD OK' );
is( $release_date, $today,     'Release date in Changes is date from today'   );
