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

has 'search_scraper' => (
	is => 'rw',
	isa => 'Web::Scraper',
	default => sub {
		return scraper {
			process '#search_results article', 'recipes[]' => scraper {
				process 'h2 a', 'url' => '@href', 'title' => sub { return $_->as_trimmed_text(); }, 'id' => '@href';
				process 'p', 'description' => sub { return $_->as_trimmed_text(); };
			};
		};
	}
);

has 'getRecipe_scraper' => (
	is => 'rw',
	isa => 'Web::Scraper',
	default => sub {
		return scraper {
			process 'h3.fn', 'title' => sub { return $_->as_trimmed_text(); };
			process '.recipe-about span.yield', 'recipe_yield' => sub { my $t =  $_->as_trimmed_text(); $t =~ s/Serves\s+//i; return $t; };
		};
	}
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
	
	
	
	my $results = $self->search_scraper->scrape($page->{content});
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
	
	my $url = $recipe;
	
	my $page = $self->pullURL($url, 1);
	
	return $page;
	
	my $results = $self->getRecipe_scraper->scrape($page->{content});
	my $ret_val = {};
	
	if ($page->{content} =~ m/<Attribute\s+name="entry_id">(?<entry_id>\d+)<\/Attribute>/i) {
		$ret_val->{entry_id} = $+{entry_id};
	} else {
		$ret_val->{entry_id} = '';
	}
	
	return $ret_val;
		
}

1;