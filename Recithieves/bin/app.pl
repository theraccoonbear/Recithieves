#!/usr/bin/env perl
use strict;
use warnings;
use Dancer;
use Dancer::Request;
use utf8::all;
use FindBin;
use lib "$FindBin::Bin/../../lib";
#use lib "$FindBin::Bin/../lib";
use API;

my $req = Dancer::Request->new(env => \%ENV);

print STDERR "LOG: app.pl run: " . $req->uri() . "\n";

get '/' => sub {
	template 'home';
};
	

dance;