package Recithieves::Source::CooksIllustrated;
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
				process 'h3 a', 'url' => '@href', 'title' => 'TEXT';
				process 'p.description', 'description' => 'TEXT';
				process 'span.document_type', 'doc_type' => 'TEXT';
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
			process 'h2[itemprop="name"]', 'name' => sub { return $_->as_trimmed_text(); };
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
			
			my $node = 'ingredients';
			my $nodes = {};
			process '//li[@itemprop="ingredients"]/../li', 'ingers[]' => sub {
				my $ip = $_->attr('itemprop') || '';
				if (!$ip) {
					$node = $_->as_trimmed_text();
					$nodes->{$node} = [];
				} else {
					push @{ $nodes->{$node} }, $_->as_trimmed_text();
				}
				
				return undef;
			};
			
			process '//li[1]', 'new_ingers' => sub {
				return $nodes;
			};
			#$_->{organized_ingr} = $nodes;
			
			process '//li[@itemprop="ingredients"]', 'ingredients[]' => scraper {
				process '//span[1]', 'qty' => sub { return $_->as_trimmed_text(); };
				process '//span[2]', 'name' => sub { return $_->as_trimmed_text(); };
			};
			
			process '//li[@itemprop="recipeInstructions"]//div//p', 'steps[]' => sub { my $t = $_->as_trimmed_text(); $t =~ s/\d+\.\s*//; return $t; };
		};
	}
);

sub search {
  my $self = shift @_;
	my $terms = shift @_;
	
	my $params = {
		'q' => $terms,
		'document_type' => 'recipes'
	};
	
	my $url = $self->baseURL() . '/search?' . $self->encodeParams($params);
	my $page = $self->pullURL($url);
	
	my $results = $self->search_scraper->scrape($page->{content});
	my $new_results = [];
	
	foreach my $recipe (@{$results->{recipes}}) {
		#$recipe->{title} =~ s/\|.+$//gi;
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
	
	my $url = $self->baseURL() . '/recipes/' . $recipe_id;
	my $resp = $self->pullURL($url);
	
	my $ret_val = {};
	
	if ($resp->{success}) {
		#print $resp->{content}; exit(100);
		$ret_val = $self->getRecipe_scraper->scrape($resp->{content});
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