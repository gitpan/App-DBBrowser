use 5.010001;
use warnings;
use strict;
die "No support for OS" if $^O eq 'MSWin32';
use ExtUtils::MakeMaker;



WriteMakefile(
    PL_FILES         => {},
    MIN_PERL_VERSION => '5.010001',
    LICENSE          => 'perl',
    AUTHOR           => 'Matthaeus Kiem <cuer2s@gmail.com>',
    NAME             => 'App::DBBrowser',
    VERSION_FROM     => 'lib/App/DBBrowser.pm',
    EXE_FILES        => [ 'bin/db-browser' ],
    BUILD_REQUIRES   => {
        'Test::More'            => 0,
    },
    PREREQ_PM => {
        'Clone'                 => 0,
        'DBI'                   => 0,
        'Encode'                => 0,
        'File::Basename'        => 0,
        'File::Find'            => 0,
        'File::HomeDir'         => 0,
        'File::Spec::Functions' => 0,
        'Getopt::Long'          => 0,
        'JSON::XS'              => 0,
        'List::MoreUtils'       => 0,
        'List::Util'            => 0,
        'Pod::Usage'            => 0,
        'Scalar::Util'          => 0,
        'Term::Choose'          => 0,
        'Term::ProgressBar'     => 0,
        'Term::ReadKey'         => 0,
        'Text::LineFold'        => 0,
        'Unicode::GCString'     => 0,
    },
    clean => {
        FILES => 'App-DBBrowser-*',
    },
);
