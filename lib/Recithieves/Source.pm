package Recithieves::Source;
use lib '../..';

use Moose;

use utf8::all;
use Cache::File;
use IO::Socket::SSL qw();
use WWW::Mechanize qw();
use Web::Scraper;
use HTTP::Cookies;
use Data::Printer;
use Text::Levenshtein qw(distance);
use JSON::XS;
use URI::Escape;
use Cwd 'abs_path';
use File::Basename;
use Recithieves::Loader;
use Digest::CRC qw(crc16);

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

has 'config' => (
	is => 'rw',
	isa => 'HashRef',
	default => sub { return {}; }
);

has 'logged_in' => (
	is => 'rw',
	isa => 'Bool',
	default => 0
);

has 'loader' => (
	is => 'rw',
	isa => 'Recithieves::Loader',
	default => sub {
		return new Recithieves::Loader();
	}
);


#my $units = {
#	'cups?' => 'c.',
#	'c\.?' => 'c.',
#	'tablespoons?' => 'T.',
#	'tbsp' => 'T.',
#	'TBSP\.?' => 'T.',
#	'T\.?' => 'T.',
#	'teaspoons?' => 't.',
#	'tsp' => 't.',
#	't\.?' => 't.',
#	'ounces?' => 'oz.',
#	'ozs?\.?' => 'oz.',
#	'(fl\.?|fluid)\s+(ounces?|ozs?\.?)' => 'fl. oz.',
#	'pints?' => 'pt.',
#	'pt\.?' => 'pt.',
#	'quarts?' => 'qt.',
#	'qts?\.?' => 'qt.',
#	'gallons?' => 'gal.',
#	'gals?\.?' => 'gal.',
#	'pounds?' => 'lbs.',
#	'lbs?\.?' => 'lbs.',
#	'packages?' => 'pkg.',
#	'pkg\.?' => 'pkg.',
#	'liters?' => 'L.',
#	'L\.?' => 'L.',
#	'm[lL]' => 'mL',
#	'[Dd]ash(es)?' => 'dash',
#	'[Pp]inch(es)?' => 'pinch',
#	'each' => 'each'
#};

my $units;
my $unit_rgx;

sub BUILD {
	my $self = shift @_;
	
	my $path = 'units-map.json';
	$units = $self->loader->load($path);
	$unit_rgx = join('|', sort { lc($a) cmp lc($b) } keys %$units);
}

#p($unit_rgx); exit(0);

has 'mech' => (
	'is' => 'rw',
	'isa' => 'WWW::Mechanize',
	'default' => sub {
		
		# UA pass through when HTTP client making request
		my $ua_string = $ENV{HTTP_USER_AGENT} || "Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.4 (KHTML, like Gecko) Chrome/22.0.1229.79 Safari/537.4";
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

sub genID {
	my $self = shift @_;
	my $str = shift @_;
	
	return uc(sprintf("%04x", crc16($str)));
}

sub err {
	my $self = shift @_;
	my $msg = shift @_ || 'Unkown Error';
	$self->log($msg, 'ERROR');
	exit(0);
}

sub warn {
	my $self = shift @_;
	my $msg = shift @_ || 'Unkown Warning';
	$self->log($msg, 'WARNING');
}

sub log {
	my $self = shift @_;
	my $msg = shift @_ || '...';
	my $type = shift @_ || 'LOG';
	
	print STDERR "$type: $msg\n";
}

sub baseURL() {
	my $self = shift @_;
	
	my $url = $self->protocol . '://' . $self->hostname . ':' .$self->port;
	return $url;
}

sub parseIngredient {
	my $self = shift @_;
	my $ing = shift @_;
	
	my $new_ing = $ing;
	
	my $ing_rgx = '^((?<qty>(?<num>\d+)(\/(?<den>\d+))?)\s+)?(\b(?<unit>' . $unit_rgx . ')\b\s+)?(?<name>.+)$';
	
	if ($ing =~ m/$ing_rgx/) {
		my $qty = $+{qty} ? ($+{den} ? $+{num} / $+{den} : $+{qty}) : 1;
		my $name = $+{name};
		my $found = 0;
		my $unit = $+{unit} || 'each';
		
		foreach my $r (keys %$units) {
			if ($unit =~ m/^$r$/) {
				$unit = $units->{$r};
				$found = 1;
				last;
			}
		}
		
		if (!$found) { $unit = 'each'; }
		
		
		$new_ing = {
			qty => $qty,
			unit => $unit,
			name => $name
		};
	}
	
	return $new_ing;
}

sub pullURL {
	my $self = shift @_;
	my $url = shift @_;
	my $no_cache = shift @_ || 0;
	
	
	my $ret = {
		success => 0,
		content => ''
	}; 
	
	if ($no_cache || !$self->cache->exists($url)) {
		$self->log("pulling $url");
		$self->mech->get($url);
		if ($self->mech->success) {
			$ret->{success} = 1;
			$ret->{content} = $self->mech->{content};
			$self->cache->set($url, encode_json($ret));
		} else {
			$ret->{success} = 0;
			$ret->{content} = '';
		}
	} else {
		$self->log("using cached $url");
		$ret = decode_json($self->cache->get($url));
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