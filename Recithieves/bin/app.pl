#!/usr/bin/env perl
use strict;
use warnings;
use Dancer;
use utf8::all;
use FindBin;
use lib "$FindBin::Bin/../../lib";
#use lib "$FindBin::Bin/../lib";
use API;

get '/' => sub {
	template 'home';
};
	

dance;