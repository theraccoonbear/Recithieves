use utf8;
package Recithieves::Schema::Result::Ingredient;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Recithieves::Schema::Result::Ingredient

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<ingredients>

=cut

__PACKAGE__->table("ingredients");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'ingredients_id_seq'

=head2 name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 1
  size: 255

=head2 qty

  data_type: 'integer'
  default_value: 0
  is_nullable: 1

=head2 recipe_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 unit

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
    sequence          => "ingredients_id_seq",
  },
  "name",
  { data_type => "varchar", default_value => "", is_nullable => 1, size => 255 },
  "qty",
  { data_type => "integer", default_value => 0, is_nullable => 1 },
  "recipe_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "unit",
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

=head2 C<ingredients_id_key>

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->add_unique_constraint("ingredients_id_key", ["id"]);

=head1 RELATIONS

=head2 recipe

Type: belongs_to

Related object: L<Recithieves::Schema::Result::Recipe>

=cut

__PACKAGE__->belongs_to(
  "recipe",
  "Recithieves::Schema::Result::Recipe",
  { id => "recipe_id" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-04-18 09:04:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:6K7txnZTQGlPzgXbJ4AsJQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
