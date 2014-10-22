use 5.010001;
use strict;
use warnings;
use Test::More;

use Test::Spelling;


add_stopwords( <DATA> );

all_pod_files_spelling_ok( 'bin', 'lib' );



__DATA__
BNRY
PrintTable
Colwidth
Ctrl
Kiem
Lk
Matthäus
ProgressBar
Sssc
Tabwidth
compat
repexp
