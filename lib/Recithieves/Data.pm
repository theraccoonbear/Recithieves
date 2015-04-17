package Recithieves::Data;

use Moose;

extends 'Recithieves';

use Data::Printer;
use Recithieves::Schema;

#my $schema = MyApp::Schema->connect($dbi_dsn, $user, $pass, \%dbi_params);
has 'schema' => (
	is => 'rw',
	isa => 'Recithieves::Schema'
);

sub BUILD {	
	my $self = shift;
	my $db = $self->config->{database};
	$self->schema(Recithieves::Schema->connect($db->{dsn}, $db->{username}, $db->{password}, $db->{params}));
}

sub allRecipes {
	my $self = shift;
	return $self->schema->resultset('Recipes');
}

1;