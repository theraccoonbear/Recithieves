use utf8;
package Recithieves::Schema::Result::Source;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Recithieves::Schema::Result::Source

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<sources>

=cut

__PACKAGE__->table("sources");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'sources_id_seq'

=head2 base_url

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 1
  size: 255

=head2 name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 1
  size: 255

=head2 created

  data_type: 'timestamp with time zone'
  is_nullable: 1

=head2 archived

  data_type: 'boolean'
  default_value: false
  is_nullable: 1

=head2 modified

  data_type: 'timestamp with time zone'
  default_value: '1970-01-01 00:00:01-06'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "sources_id_seq",
  },
  "base_url",
  { data_type => "varchar", default_value => "", is_nullable => 1, size => 255 },
  "name",
  { data_type => "varchar", default_value => "", is_nullable => 1, size => 255 },
  "created",
  { data_type => "timestamp with time zone", is_nullable => 1 },
  "archived",
  { data_type => "boolean", default_value => \"false", is_nullable => 1 },
  "modified",
  {
    data_type     => "timestamp with time zone",
    default_value => "1970-01-01 00:00:01-06",
    is_nullable   => 1,
  },
);

=head1 UNIQUE CONSTRAINTS

=head2 C<sources_id_key>

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->add_unique_constraint("sources_id_key", ["id"]);

=head1 RELATIONS

=head2 recipes

Type: has_many

Related object: L<Recithieves::Schema::Result::Recipe>

=cut

__PACKAGE__->has_many(
  "recipes",
  "Recithieves::Schema::Result::Recipe",
  { "foreign.source_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-04-17 15:42:46
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:1380Hlru79ZGoetiTe1xtw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
