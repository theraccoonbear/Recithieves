<?php
namespace App\Test\Fixture;

use Cake\TestSuite\Fixture\TestFixture;

/**
 * RecipesFixture
 *
 */
class RecipesFixture extends TestFixture
{

    /**
     * Fields
     *
     * @var array
     */
    // @codingStandardsIgnoreStart
    public $fields = [
        'id' => ['type' => 'integer', 'length' => 10, 'autoIncrement' => true, 'default' => null, 'null' => false, 'comment' => null, 'precision' => null, 'unsigned' => null],
        'description' => ['type' => 'text', 'length' => null, 'default' => '', 'null' => true, 'comment' => null, 'precision' => null],
        'directions' => ['type' => 'text', 'length' => null, 'default' => '[]', 'null' => true, 'comment' => null, 'precision' => null],
        'photo' => ['type' => 'string', 'length' => 255, 'default' => '', 'null' => true, 'comment' => null, 'precision' => null, 'fixed' => null],
        'serves' => ['type' => 'string', 'length' => 255, 'default' => '', 'null' => true, 'comment' => null, 'precision' => null, 'fixed' => null],
        'source_id' => ['type' => 'integer', 'length' => 10, 'default' => null, 'null' => true, 'comment' => null, 'precision' => null, 'unsigned' => null, 'autoIncrement' => null],
        'title' => ['type' => 'string', 'length' => 255, 'default' => '', 'null' => true, 'comment' => null, 'precision' => null, 'fixed' => null],
        'created' => ['type' => 'timestamp', 'length' => null, 'default' => null, 'null' => true, 'comment' => null, 'precision' => null],
        'archived' => ['type' => 'boolean', 'length' => null, 'default' => 0, 'null' => true, 'comment' => null, 'precision' => null],
        'modified' => ['type' => 'timestamp', 'length' => null, 'default' => '1970-01-01 06:00:01+00', 'null' => true, 'comment' => null, 'precision' => null],
        '_constraints' => [
            'primary' => ['type' => 'primary', 'columns' => ['id'], 'length' => []],
            'recipes_source_id_fkey' => ['type' => 'foreign', 'columns' => ['source_id'], 'references' => ['sources', 'id'], 'update' => 'noAction', 'delete' => 'noAction', 'length' => []],
        ],
    ];
    // @codingStandardsIgnoreEnd

    /**
     * Records
     *
     * @var array
     */
    public $records = [
        [
            'id' => 1,
            'description' => 'Lorem ipsum dolor sit amet, aliquet feugiat. Convallis morbi fringilla gravida, phasellus feugiat dapibus velit nunc, pulvinar eget sollicitudin venenatis cum nullam, vivamus ut a sed, mollitia lectus. Nulla vestibulum massa neque ut et, id hendrerit sit, feugiat in taciti enim proin nibh, tempor dignissim, rhoncus duis vestibulum nunc mattis convallis.',
            'directions' => 'Lorem ipsum dolor sit amet, aliquet feugiat. Convallis morbi fringilla gravida, phasellus feugiat dapibus velit nunc, pulvinar eget sollicitudin venenatis cum nullam, vivamus ut a sed, mollitia lectus. Nulla vestibulum massa neque ut et, id hendrerit sit, feugiat in taciti enim proin nibh, tempor dignissim, rhoncus duis vestibulum nunc mattis convallis.',
            'photo' => 'Lorem ipsum dolor sit amet',
            'serves' => 'Lorem ipsum dolor sit amet',
            'source_id' => 1,
            'title' => 'Lorem ipsum dolor sit amet',
            'created' => 1441641602,
            'archived' => 1,
            'modified' => 1441641602
        ],
    ];
}
