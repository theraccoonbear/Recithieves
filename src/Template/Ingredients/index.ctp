<div class="actions columns large-2 medium-3">
    <h3><?= __('Actions') ?></h3>
    <ul class="side-nav">
        <li><?= $this->Html->link(__('New Ingredient'), ['action' => 'add']) ?></li>
        <li><?= $this->Html->link(__('List Recipes'), ['controller' => 'Recipes', 'action' => 'index']) ?></li>
        <li><?= $this->Html->link(__('New Recipe'), ['controller' => 'Recipes', 'action' => 'add']) ?></li>
    </ul>
</div>
<div class="ingredients index large-10 medium-9 columns">
    <table cellpadding="0" cellspacing="0">
    <thead>
        <tr>
            <th><?= $this->Paginator->sort('id') ?></th>
            <th><?= $this->Paginator->sort('name') ?></th>
            <th><?= $this->Paginator->sort('qty') ?></th>
            <th><?= $this->Paginator->sort('recipe_id') ?></th>
            <th><?= $this->Paginator->sort('unit') ?></th>
            <th><?= $this->Paginator->sort('created') ?></th>
            <th><?= $this->Paginator->sort('archived') ?></th>
            <th class="actions"><?= __('Actions') ?></th>
        </tr>
    </thead>
    <tbody>
    <?php foreach ($ingredients as $ingredient): ?>
        <tr>
            <td><?= $this->Number->format($ingredient->id) ?></td>
            <td><?= h($ingredient->name) ?></td>
            <td><?= $this->Number->format($ingredient->qty) ?></td>
            <td>
                <?= $ingredient->has('recipe') ? $this->Html->link($ingredient->recipe->title, ['controller' => 'Recipes', 'action' => 'view', $ingredient->recipe->id]) : '' ?>
            </td>
            <td><?= h($ingredient->unit) ?></td>
            <td><?= h($ingredient->created) ?></td>
            <td><?= h($ingredient->archived) ?></td>
            <td class="actions">
                <?= $this->Html->link(__('View'), ['action' => 'view', $ingredient->id]) ?>
                <?= $this->Html->link(__('Edit'), ['action' => 'edit', $ingredient->id]) ?>
                <?= $this->Form->postLink(__('Delete'), ['action' => 'delete', $ingredient->id], ['confirm' => __('Are you sure you want to delete # {0}?', $ingredient->id)]) ?>
            </td>
        </tr>

    <?php endforeach; ?>
    </tbody>
    </table>
    <div class="paginator">
        <ul class="pagination">
            <?= $this->Paginator->prev('< ' . __('previous')) ?>
            <?= $this->Paginator->numbers() ?>
            <?= $this->Paginator->next(__('next') . ' >') ?>
        </ul>
        <p><?= $this->Paginator->counter() ?></p>
    </div>
</div>
