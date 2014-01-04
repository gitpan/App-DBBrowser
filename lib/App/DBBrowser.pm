package App::DBBrowser;

use warnings;
use strict;
use 5.10.1;

our $VERSION = '0.002';


1;

__END__

=pod

=encoding UTF-8

=head1 NAME

App::DBBrowser - Search and read in SQLite/MySQL/PostgreSQL databases.

=head1 VERSION

Version 0.002

=head1 SYNOPSIS

=head2 SQLite/MySQL/PostgreSQL

db-browser

db-browser -h|--help

    -h|--help    show the config menu (which offers also a help text).

=head2 SQLite

db-browser [-s|--search] [directories to be searched]

If no directories are passed the home directory is searched for SQLite databases.

    -s|--search    new search of SQLite databases (don't use cached data).

=head1 DESCRIPTION

Search and read in SQLite/MySQL/PostgreSQL databases.

For further information see L<db-browser>

=head1 AUTHOR

Matthäus Kiem <cuer2s@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2012-2014 Matthäus Kiem.

This is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=cut
