package Recithieves::Loader;

use Moose;

extends 'Recithieves';

use lib '../..';

use utf8::all;
use Cache::File;
use Data::Printer;
use File::Slurp;
use JSON::XS;
use Cwd 'abs_path';
use File::Basename;


sub load {
	my $self = shift @_;
	my $file = shift @_;
	
	my $ret_val = {};
	
	if (! -f $file) {
		$file = abs_path(dirname(abs_path(__FILE__)) . "/../../data/" . $file);
	}
	
	
	if (-f $file) {
		$ret_val = decode_json(read_file($file));
	} else {
		print STDERR "Can't load $file";
		exit(0);
	}
	
	return $ret_val;
}

1;