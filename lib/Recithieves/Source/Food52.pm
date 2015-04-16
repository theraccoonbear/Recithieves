package Recithieves::Source::Food52;
use lib '../..';

use Moose;

extends 'Recithieves::Source';

use IO::Socket::SSL qw();
use WWW::Mechanize qw();
use Web::Scraper;
use HTTP::Cookies;
use Data::Printer;
use JSON::XS;
use URI::Escape;
use Web::Scraper;

has '+hostname' => (
	is => 'rw',
	isa => 'Str',
	default => 'www.food52.com'
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
	is => 'ro',
	isa => 'Web::Scraper',
	default => sub {
		return scraper {
			process '//div[@data-type="recipe"]', 'recipes[]' => scraper {
				process 'h3 a', 'title' => '@title';
				process '//../div[@data-type="recipe"]', 'id' => '@data-id';
				process 'img', 'photo' => '@data-original';
				process '//..', 'description' => sub { return '...'; };
			};
		};
	}
);

has 'getRecipe_scraper' => (
	is => 'ro',
	isa => 'Web::Scraper',
	default => sub {
		my $self = shift @_;
		return scraper {
			
		};
	}
);

sub search {
  my $self = shift @_;
	my $terms = shift @_;
	
	my $params = {
		'q' => $terms
	};
	
	my $url = $self->baseURL() . '/recipes/search?' . $self->encodeParams($params);
	my $page = $self->pullURL($url);
	my $results = $self->search_scraper->scrape($page->{content});
	my $new_results = [];
	
	foreach my $recipe (@{$results->{recipes}}) {
		push @$new_results, $recipe;
	}
	
	return $new_results;
}

sub getRecipe {
	my $self = shift @_;
	my $recipe_id = shift @_;
	
	my $url = $recipe_id;
	
	if ($recipe_id =~ m/^\d+$/) {
		$url = $self->baseURL() . '/recipes/' . $recipe_id;
	}
	
	my $resp = $self->pullURL($url);
	
	my $ret_val = {};
	
	if ($resp->{success}) {
		#print $resp->{content}; exit(100);
		$ret_val = $self->getRecipe_scraper->scrape($resp->{content});
		
		$ret_val->{ingredients} = {};
		my $section = 'all';
		foreach my $ing (@{ $ret_val->{_ingredients} }) {
			if ($ing->{section}) {
				$section = $ing->{section};
				$ret_val->{ingredients}->{$section} = [];
			} else {
				push @{ $ret_val->{ingredients}->{$section} }, $self->parseIngredient($ing->{_raw});
			}
		}
		delete $ret_val->{_ingredients};
	}
	
	return $ret_val;
}

sub login {
	my $self = shift @_;
	
	my $username = shift @_ || '';
	my $password = shift @_ || '';
	my $ret_val = 0;
	
	if (length($username) < 1) {
		$username = $self->config->{'cooks-illustrated'}->{username};
	}
	
	if (length($password) < 1) {
		$password = $self->config->{'cooks-illustrated'}->{password};
	}
	
	
	my $url = $self->baseURL() . '/sign_in';
	
	$self->mech->get($url);
	
	if ($self->mech->success) {
		$self->mech->submit_form(
			form_number => 5,
			fields => {
				'user[email]' => $username,
				'user[password]' => $password
			}
		);
		
		if ($self->mech->success) {
			if ($self->mech->content !~ m/incorrect password/i) {
				$ret_val = 1;
			}
		}
	}		
	
	$self->logged_in($ret_val != 0);
	
	return $ret_val;
}

1;