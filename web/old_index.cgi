#!/usr/bin/env perl
use strict;
use warnings;
#use lib "../lib";
use FindBin;
use lib "$FindBin::Bin/../lib";

use CGI::Carp qw(fatalsToBrowser);

use Dancer;

use JSON::XS;
use Getopt::Long;
use Data::Dumper;
use Data::Printer;
use File::Slurp;
use POSIX;
use Cwd 'abs_path';
use File::Basename;

use Recithieves::Source::CooksIllustrated;

my $config_file = dirname(abs_path($0)) . "/../config/config.json";

my $config = {};
my $script_started = time();

if ($config_file && -f $config_file) {
	my $file_data = read_file($config_file);
	$config = decode_json($file_data);
} else {
	die "No config file specified";
}

my $ci = new Recithieves::Source::CooksIllustrated(config => $config);

any '/' => sub {
	content_type 'text/plain';
	print "It's working!";
};

any '/api/search/:source/:term' => sub {
	content_type 'text/plain';
	return "searching " . param('source') . " for \"" . param('term') . '"';
	#my $sources = {
	#	'cooks' => $ci
	#};
	#
	#my $src = $sources->{param('source')};
	#return encode_json($src->search(param('term')));
};



#Dancer->dance();