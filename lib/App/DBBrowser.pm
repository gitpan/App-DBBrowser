package App::DBBrowser;

use warnings;
use strict;
use 5.10.1;

our $VERSION = '0.022';


1;

__END__

=pod

=encoding UTF-8

=head1 NAME

App::DBBrowser - Search and read in SQLite/MySQL/PostgreSQL databases.

=head1 VERSION

Version 0.022

=head1 SYNOPSIS

=head2 SQLite/MySQL/PostgreSQL

    db-browser

    db-browser -h|--help

C<db-browser> called with C<-h|--help> shows a menu which offers also a HELP text.

=head2 SQLite

    db-browser [-s|--search] [directories to be searched]

If no directories are passed the home directory is searched for SQLite databases.

C<db-browser> called with C<-s|--search> causes a new search of SQLite databases.

=head1 DESCRIPTION

Search and read in SQLite/MySQL/PostgreSQL databases.

For further information see L<db-browser>.

=head1 REQUIREMENTS

It is required Perl version 5.10.1 or greater.

It is recommended to work with an UTF encoding since non mappable characters might break the output.

See also the requirements mentioned in L<Term::Choose> which itself is required by the C<db-browser>.

=head1 AUTHOR

Matthäus Kiem <cuer2s@gmail.com>

=head1 CREDITS

Thanks to the L<Perl-Community.de|http://www.perl-community.de> and the people form
L<stackoverflow|http://stackoverflow.com> for the help.

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012-2014 Matthäus Kiem.

This program is free software; you can redistribute it and/or modify it under the same terms as Perl 5.10.0. For
details, see the full text of the licenses in the file LICENSE.

=cut
