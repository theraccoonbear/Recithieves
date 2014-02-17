#!/usr/bin/perl
use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";

use Recithieves::Source::SeriousEats;

use JSON::XS;
use Getopt::Long;
use Data::Dumper;
use File::Slurp;
use POSIX;
use Cwd 'abs_path';
use File::Basename;

my $previous_fh = select(STDOUT); $| = 1; select($previous_fh);

# Config
my $config_file = dirname(abs_path($0)) . "/config/config.json";

my $config = {};
my $script_started = time();

GetOptions(
	'config=s' => \$config_file
);

if ($config_file && -f $config_file) {
	my $file_data = read_file($config_file);
	$config = decode_json($file_data);
} else {
	die "No config file specified";
}


my $se = new Recithieves::Source::SeriousEats();

my $results = $se->search('pork');

print Dumper($results);