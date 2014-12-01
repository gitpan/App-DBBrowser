package # hide from PAUSE
App::DBBrowser::DB::mysql;

use warnings FATAL => 'all';
use strict;
use 5.010000;
no warnings 'utf8';

#our $VERSION = '';

use DBI qw();

use App::DBBrowser::DB_Credentials;


sub new {
    my ( $class, $info, $opt ) = @_;
    bless { info => $info, opt => $opt }, $class;
}


#sub database_driver {
#    my ( $self ) = @_;
#    return 'mysql';
#}


sub get_db_handle {
    my ( $self, $db, $db_arg ) = @_;
    $db_arg //= {};
    my $obj_db_cred = App::DBBrowser::DB_Credentials->new( $self->{info}, $self->{opt} );
    my $dsn  = 'dbi:mysql:dbname=' . $db; ##
    my $host = $obj_db_cred->__get_host_or_port( $db, 'host' );
    my $port = $obj_db_cred->__get_host_or_port( $db, 'port' );
    $dsn .= ';host=' . $host if length $host;
    $dsn .= ';port=' . $port if length $port;
    my $user   = $obj_db_cred->__get_user( $db );
    my $passwd = $obj_db_cred->__get_password( $db, $user );
    my $dbh = DBI->connect( $dsn, $user, $passwd, {
        PrintError => 0,
        RaiseError => 1,
        AutoCommit => 1,
        ShowErrorStatement => 1,
        %$db_arg,
    } ) or die DBI->errstr;
    return $dbh;
}


sub available_databases {
    my ( $self, $metadata ) = @_;
    my $regexes = $self->regexp_system( 'database' );
    my $stmt = "SELECT schema_name FROM information_schema.schemata";
    if ( ! $metadata ) {
        $stmt .= " WHERE " . join( " AND ", ( "schema_name NOT REGEXP ?" ) x @$regexes );
    }
    $stmt .= " ORDER BY schema_name";
    my $dbh = $self->get_db_handle( 'information_schema' ); # $db_arg
    my $databases = $dbh->selectcol_arrayref( $stmt, {}, $metadata ? () : @$regexes );
    $dbh->disconnect(); #
    if ( $metadata ) {
        my $regexp = join '|', @$regexes;
        my $user_db   = [];
        my $system_db = [];
        for my $database ( @{$databases} ) {
            if ( $database =~ /(?:$regexp)/ ) {
                push @$system_db, $database;
            }
            else {
                push @$user_db, $database;
            }
        }
        return $user_db, $system_db;
    }
    else {
        return $databases, [];
    }
}


sub get_schema_names {
    my ( $self, $dbh, $db, $metadata ) = @_;
    return [ $db ];
}


sub get_table_names {
    my ( $self, $dbh, $schema, $metadata ) = @_;
    my $stmt = "SELECT table_name FROM information_schema.tables
                    WHERE table_schema = ?
                    ORDER BY table_name";
                    # AND table_type = 'BASE TABLE'
    my $tables = $dbh->selectcol_arrayref( $stmt, {}, ( $schema ) );
    return $tables;
}


sub regexp_system {
    my ( $self, $level ) = @_;
    return [ '^mysql$', '^information_schema$', '^performance_schema$' ] if $level eq 'database';
    return                                                               if $level eq 'schema'; #
    return                                                               if $level eq 'table';

}


sub column_names_and_types {
    my ( $self, $dbh, $db, $schema, $tables ) = @_;
    my ( $col_names, $col_types );
    my $stmt = "SELECT table_name, column_name, column_type
                    FROM information_schema.columns
                    WHERE table_schema = ?";
    my $sth = $dbh->prepare( $stmt );
    $sth->execute( $schema );
    while ( my $row = $sth->fetchrow_arrayref() ) {
        my ( $table, $col_name, $col_type ) = @$row;
        push @{$col_names->{$table}}, $col_name;
        push @{$col_types->{$table}}, $col_type;
    }
    return $col_names, $col_types;
}


sub primary_and_foreign_keys {
    my ( $self, $dbh, $db, $schema, $tables ) = @_;
    my $pk_cols = {};
    my $fks     = {};
    for my $table ( @$tables ) {
        my $stmt = "SELECT constraint_name, table_name, column_name, referenced_table_name,
                            referenced_column_name, position_in_unique_constraint
                        FROM information_schema.key_column_usage
                        WHERE table_schema = ? AND table_name = ? AND referenced_table_name IS NOT NULL";
        my $sth = $dbh->prepare( $stmt );
        $sth->execute( $schema, $table );
        while ( my $row = $sth->fetchrow_hashref ) {
            my $fk_name = $row->{constraint_name};
            my $pos     = $row->{position_in_unique_constraint} - 1;
            $fks->{$table}{$fk_name}{foreign_key_col}  [$pos] = $row->{column_name};
            $fks->{$table}{$fk_name}{reference_key_col}[$pos] = $row->{referenced_column_name};
            if ( ! $fks->{$table}{$fk_name}{reference_table} ) {
                $fks->{$table}{$fk_name}{reference_table} = $row->{referenced_table_name};
            }
        }
        $pk_cols->{$table} = [ $dbh->primary_key( undef, $schema, $table ) ];
    }
    return $pk_cols, $fks;
}


sub sql_regexp {
    my ( $self, $quote_col, $is_not_regexp, $case_sensitive ) = @_;
    if ( $is_not_regexp ) {
        return ' '. $quote_col . ' NOT REGEXP ?'        if ! $case_sensitive;
        return ' '. $quote_col . ' NOT REGEXP BINARY ?' if   $case_sensitive;
    }
    else {
        return ' '. $quote_col . ' REGEXP ?'            if ! $case_sensitive;
        return ' '. $quote_col . ' REGEXP BINARY ?'     if   $case_sensitive;
    }
}


sub concatenate {
    my ( $self, $arg ) = @_;
    return 'concat(' . join( ',', @$arg ) . ')';
}


# scalar functions


sub epoch_to_datetime {
    my ( $self, $col, $interval ) = @_;
    # mysql: FROM_UNIXTIME doesn't work with negative timestamps
    return "FROM_UNIXTIME($col/$interval,'%Y-%m-%d %H:%i:%s')";
}

sub epoch_to_date {
    my ( $self, $col, $interval ) = @_;
    return "FROM_UNIXTIME($col/$interval,'%Y-%m-%d')";
}

sub truncate {
    my ( $self, $col, $precision ) = @_;
    return "TRUNCATE($col,$precision)";
}

sub bit_length {
    my ( $self, $col ) = @_;
    return "BIT_LENGTH($col)";
}

sub char_length {
    my ( $self, $col ) = @_;
    return "CHAR_LENGTH($col)";
}




1;


__END__
