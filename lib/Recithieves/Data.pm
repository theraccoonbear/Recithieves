package Recithieves::Data;

use Moose;

extends 'Recithieves';

use Data::Printer;
use Recithieves::Schema;
use JSON::XS;

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

sub allSources {
	my $self = shift;
	my @sources = $self->schema->resultset('Source')->all;
	return \@sources;
}

sub allRecipes {
	my $self = shift;
	my @recipes = $self->schema->resultset('Recipe')->all;
	return \@recipes;
}

sub recipe {
	my $self = shift;
	return $self->schema->resultset('Recipe');
}

sub prepareRecipe {
	my $self = shift @_;
	my $recipe = shift @_;
	
	my $ret_val = {
		title => $recipe->{title} || '...',
		description => $recipe->{description} || '...',
		serves => $recipe->{recipe_yield} || '...',
		directions => encode_json($recipe->{steps} || [])
	};
	
	return $ret_val;
}

1;