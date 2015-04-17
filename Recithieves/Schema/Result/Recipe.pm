use utf8;
package Recithieves::Schema::Result::Recipe;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Recithieves::Schema::Result::Recipe

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<recipes>

=cut

__PACKAGE__->table("recipes");

=head1 ACCESSORS

=head2 source_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'recipes_id_seq'

=head2 serves

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 1
  size: 255

=head2 title

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 1
  size: 255

=head2 archived

  data_type: 'boolean'
  default_value: false
  is_nullable: 1

=head2 modified

  data_type: 'timestamp with time zone'
  default_value: '1970-01-01 00:00:01-06'
  is_nullable: 1

=head2 created

  data_type: 'timestamp with time zone'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "source_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "recipes_id_seq",
  },
  "serves",
  { data_type => "varchar", default_value => "", is_nullable => 1, size => 255 },
  "title",
  { data_type => "varchar", default_value => "", is_nullable => 1, size => 255 },
  "archived",
  { data_type => "boolean", default_value => \"false", is_nullable => 1 },
  "modified",
  {
    data_type     => "timestamp with time zone",
    default_value => "1970-01-01 00:00:01-06",
    is_nullable   => 1,
  },
  "created",
  { data_type => "timestamp with time zone", is_nullable => 1 },
);

=head1 UNIQUE CONSTRAINTS

=head2 C<recipes_id_key>

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->add_unique_constraint("recipes_id_key", ["id"]);

=head1 RELATIONS

=head2 ingredients

Type: has_many

Related object: L<Recithieves::Schema::Result::Ingredient>

=cut

__PACKAGE__->has_many(
  "ingredients",
  "Recithieves::Schema::Result::Ingredient",
  { "foreign.recipe_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 source

Type: belongs_to

Related object: L<Recithieves::Schema::Result::Source>

=cut

__PACKAGE__->belongs_to(
  "source",
  "Recithieves::Schema::Result::Source",
  { id => "source_id" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-04-17 15:42:46
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:YW8M3Y3cWUB7sq5rcSlzdg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
