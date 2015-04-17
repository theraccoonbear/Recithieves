package Recithieves;

use Moose;

has 'config' => (
	is => 'rw',
	isa => 'HashRef',
	default => sub {
		return {};
	}
);

1;