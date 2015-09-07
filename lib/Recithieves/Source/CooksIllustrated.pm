package Recithieves::Source::CooksIllustrated;
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
	default => 'www.cooksillustrated.com'
);

has '+port' => (
	is => 'rw',
	isa => 'Int',
	default => 443
);

has '+protocol' => (
	is => 'rw',
	isa => 'Str',
	default => 'https'
);

has 'search_scraper' => (
	is => 'ro',
	isa => 'Web::Scraper',
	default => sub {
		return scraper {
			process 'ul.search li.available', 'recipes[]' => scraper {
				process 'h3 a', 'url' => '@href', 'title' => sub { return $_->as_trimmed_text(); };
				process 'p.description', 'description' => sub { return $_->as_trimmed_text(); };
				process 'span.document_type', 'doc_type' => sub { return $_->as_trimmed_text(); };
				process 'a.photo', 'photo' => '@style';
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
			process 'h2[itemprop="name"]', 'title' => sub { return $_->as_trimmed_text(); };
			process 'h4[itemprop="recipeYield"]', 'recipe_yield' => sub {
				my $t = $_->as_trimmed_text();
				my $lower = 1;
				my $upper;
				if ($t =~ m/Serves\s+(?<lower>\d+)(\s+to\s+(?<upper>\d+))?/i) {
					$lower = $+{lower};
					$upper = $+{upper};
				}
				
				return $upper ? "$lower-$upper" : $lower;
			};
			process 'section.serves p', 'description' => 'TEXT';
			
			my $section = 'all';
			process '//li[@itemprop="ingredients"]/../li', '_ingredients[]' => scraper {
				process '//span[1]', "qty" => sub { return $_->as_trimmed_text(); };
				process '//span[2]', "name" => sub { return $_->as_trimmed_text(); };
				process 'h5', 'section' => sub { $section = $_->as_trimmed_text(); };
				process './/', '_raw' => sub { $section = $_->as_trimmed_text(); };
			};
			
			process '//li[@itemprop="recipeInstructions"]//div//p', 'steps[]' => sub { my $t = $_->as_trimmed_text(); $t =~ s/\d+\.\s*//; return $t; };
		};
	}
);

sub search {
  my $self = shift @_;
	my $terms = shift @_;
	
	if (!$self->logged_in) { $self->login(); }
	
	
	my $params = {
		'q' => $terms,
		'document_type' => 'recipes'
	};
	
	my $url = $self->baseURL() . '/search?' . $self->encodeParams($params);
	my $page = $self->pullURL($url);
	
	my $results = $self->search_scraper->scrape($page->{content});
	my $new_results = [];
	
	foreach my $recipe (@{$results->{recipes}}) {
		if ($recipe->{doc_type} =~ m/recipe/i && $recipe->{url} =~ m/\/recipes\/(?<id>\d+)/i) {
			$recipe->{id} = $+{id};
			$recipe->{photo} = $recipe->{photo} || '';
			$recipe->{photo} =~ s/^.+?url\(([^\)]+)\).*$/$1/;
			$recipe->{photo} = $recipe->{photo} ? 'https:' . $recipe->{photo} : '';
			
			push @$new_results, $recipe;
		}
	}
	
	return $new_results;
}

sub getRecipe {
	my $self = shift @_;
	my $recipe_id = shift @_;
	
	my $url = $recipe_id;
	
	if (!$self->logged_in) { $self->login(); }
	
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
	
	$self->log('Logging into Cooks Illustrated');
	
	if ($self->mech->success) {
		my $form = $self->mech->form_number(5);
		if ($form) {
			$self->mech->submit_form(
				form_number => 5,
				fields => {
					'user[email]' => $username,
					'user[password]' => $password
				}
			);
			
			if ($self->mech->success) {
				if ($self->mech->content !~ m/incorrect password/i) {
					$self->log('Success');
					$ret_val = 1;
				} else {
					$self->log('Error Logging In');
				}
			}
		} else {
			$self->log('Already Logged In');
			$ret_val = 1;
		}
	}
	
	$self->logged_in($ret_val != 0);
	
	return $ret_val;
}

1;