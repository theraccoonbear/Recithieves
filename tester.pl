#!/usr/bin/perl
use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";

use Recithieves::Source::SeriousEats;
use Recithieves::Source::CooksIllustrated;

use JSON::XS;
use Getopt::Long;
use Data::Printer;
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


my $se = new Recithieves::Source::SeriousEats(config => $config);
my $ci = new Recithieves::Source::CooksIllustrated(config => $config);

print "Serious Eats:\n";
p($se->search('pork'));

#$ci->cache->clear(); exit(0);

#my $recipe_id;
#
#$recipe_id = 2899; # pork chops
#$recipe_id = 4662; # ziti
#
#if ($ARGV[0]) {
#	$recipe_id = $ARGV[0];
#}
#
#p($ci->getRecipe($recipe_id)); exit(0);
#
print "logging into CI...\n";
if ($ci->login()) {
	print "ok. fetching data...\n";
	print "Cooks Illustrated:\n";
	p($ci->search('pork'));
	#p($ci->getRecipe($recipe_id));
}