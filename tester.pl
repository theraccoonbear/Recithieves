#!/usr/bin/perl
use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";
use JSON::XS;
use Getopt::Long;
use Data::Printer;
use File::Slurp;
use POSIX;
use Cwd 'abs_path';
use File::Basename;

use Recithieves::Source::SeriousEats;
use Recithieves::Source::CooksIllustrated;
use Recithieves::Source::Food52;
use Recithieves::Data;

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


my $data = new Recithieves::Data(config => $config);
my $ci = new Recithieves::Source::CooksIllustrated(config => $config);
my $recipe_id = 4662;
my $recipe = $ci->getRecipe($recipe_id);

p($recipe);

#p($data->schema);
my $rs = $data->recipe();
#p($rs);

my $to_insert = $data->prepareRecipe($recipe);
p($to_insert);
$rs->create(
	$to_insert
);

#my $se = new Recithieves::Source::SeriousEats(config => $config);

#$se->cache->clear();

#my $recipe = 'http://www.seriouseats.com/recipes/2014/01/pork-sorpotel-recipe.html';

#p($se->getRecipe($recipe));

#my $ci = new Recithieves::Source::CooksIllustrated(config => $config);
#my $f52 = new Recithieves::Source::Food52(config => $config);

#p($f52->search('pork'));

#print "Serious Eats:\n";
#p($se->search('pork'));
#
##$ci->cache->clear(); exit(0);
#
##my $recipe_id;
##
##$recipe_id = 2899; # pork chops
##$recipe_id = 4662; # ziti
##
##if ($ARGV[0]) {
##	$recipe_id = $ARGV[0];
##}
##
##p($ci->getRecipe($recipe_id)); exit(0);
##
#print "logging into CI...\n";
#if ($ci->login()) {
#	print "ok. fetching data...\n";
#	print "Cooks Illustrated:\n";
#	p($ci->search('pork'));
#	#p($ci->getRecipe($recipe_id));
#}