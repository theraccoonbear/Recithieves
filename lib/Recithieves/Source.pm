package Recithieves::Source;
use lib '../..';

use Moose;

use Cache::File;
use IO::Socket::SSL qw();
use WWW::Mechanize qw();
use Web::Scraper;
use HTTP::Cookies;
use Data::Dumper;
use Text::Levenshtein qw(distance);
use JSON::XS;
use URI::Escape;

has 'hostname' => (
	is => 'rw',
	isa => 'Str'
);

has 'port' => (
	is => 'rw',
	isa => 'Int',
	default => 80
);

has 'protocol' => (
	is => 'rw',
	isa => 'Int',
	default => 'http'
);

has 'username' => (
	is => 'rw',
	isa => 'Str'
);

has 'password' => (
	is => 'rw',
	isa => 'Str'
);

has 'cache' => (
	is => 'rw',
	isa => 'Cache::File',
	default => sub {

		return Cache::File->new(
			cache_root => '/tmp/mycache',
      default_expires => '30 day'
		);
	}
);

has 'mech' => (
	'is' => 'rw',
	'isa' => 'WWW::Mechanize',
	'default' => sub {
		my $ua_string = "Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.4 (KHTML, like Gecko) Chrome/22.0.1229.79 Safari/537.4";
		my $cookie_jar = HTTP::Cookies->new();
		$cookie_jar->clear();
		my $www_mech = WWW::Mechanize->new(
			cookie_jar => $cookie_jar,
			SSL_verify_mode => IO::Socket::SSL::SSL_VERIFY_NONE,
			PERL_LWP_SSL_VERIFY_HOSTNAME => 0,
			verify_hostname => 0,
			ssl_opts => {
				verify_hostname => 0
			}
		);
		$www_mech->agent($ua_string);
		return $www_mech;
	}
);

sub baseURL() {
	my $self = shift @_;
	
	my $url = $self->protocol . '://' . $self->hostname . ':' .$self->port;
	return $url;
}

sub pullURL {
	my $self = shift @_;
	my $url = shift @_;
	
	my $ret = {
		success => 0,
		content => ''
	};
	
	$self->mech->get($url);
	if ($self->mech->success) {
		$ret->{success} = 1;
		$ret->{content} = $self->mech->{content};
	}
	
	return $ret;
}

sub objDrill {
	my $self = shift @_;
	my $obj = shift @_;
	my $drill = shift @_;
	
	foreach my $i (@$drill) {
		if (defined $obj->{$i}) {
			$obj = $obj->{$i}
		} else {
			return undef;
		}
	}
	
	return $obj;
}

sub encodeParams {
	my $self = shift @_;
	my $list = shift @_;
	my $nl = [];
	foreach my $name (keys %$list) {
		push @$nl, $self->encodeParam($name, $list->{$name});
	}
	
	return join('&', @$nl);
}

sub encodeParam {
	my $self = shift @_;
	my $name = shift @_;
	my $value = shift @_;
	
	return uri_escape($name) . '=' . uri_escape($value);
}


1;