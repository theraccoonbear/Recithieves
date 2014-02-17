package Recithieves::Source::SeriousEats;
use lib '../..';

use Moose;

extends 'Recithieves::Source';

use IO::Socket::SSL qw();
use WWW::Mechanize qw();
use Web::Scraper;
use HTTP::Cookies;
use Data::Dumper;
use JSON::XS;
use URI::Escape;
use Web::Scraper;

has '+hostname' => (
	is => 'rw',
	isa => 'Str',
	default => 'www.seriouseats.com'
);

has '+port' => (
	is => 'rw',
	isa => 'Int',
	default => 80
);

has '+protocol' => (
	is => 'rw',
	isa => 'Str',
	default => 'http'
);

sub search {
  my $self = shift @_;
	my $terms = shift @_;
	
	my $params = {
		term => $terms,
		site => 'recipes'
	};
	
	my $url = $self->baseURL() . '/search?' . $self->encodeParams($params);
	my $page = $self->pullURL($url);
	
	my $scraper = scraper {
		process '#search_results article', 'recipes[]' => scraper {
			process 'h2 a', 'url' => '@href', 'title' => 'TEXT';
		};
	};
	
	my $results = $scraper->scrape($page->{content});
	my $new_results = [];
	
	foreach my $recipe (@{$results->{recipes}}) {
		$recipe->{title} =~ s/\|.+$//gi;
		if ($recipe->{url} =~ m/\/recipes\/\d{4}\/\d{2}\//i) {
			push @$new_results, $recipe;
		}
	}
	
	return $new_results;
	
}

sub getRecipe {
	my $self = shift @_;
	my $recipe = shift @_;
	
	my $scraper = scraper {
		process '#print-recipe-form input[name="entry_id"]', 'recipe_id' => '@value';
	}
		
}

1;