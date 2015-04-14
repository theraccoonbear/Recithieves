#!/usr/bin/env perl
use strict;
use warnings;
use Dancer;

any '/' => sub {
	content_type 'text/plain';
	print "It's working!";
};

any '/api/search/:source/:term' => sub {
	content_type 'text/plain';
	return "searching " . param('source') . " for \"" . param('term') . '"';
};
