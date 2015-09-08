<div class="actions columns large-2 medium-3">
    <h3><?= __('Actions') ?></h3>
    <ul class="side-nav">
        <li><?= $this->Html->link(__('New Recipe'), ['action' => 'add']) ?></li>
        <li><?= $this->Html->link(__('List Sources'), ['controller' => 'Sources', 'action' => 'index']) ?></li>
        <li><?= $this->Html->link(__('New Source'), ['controller' => 'Sources', 'action' => 'add']) ?></li>
        <li><?= $this->Html->link(__('List Ingredients'), ['controller' => 'Ingredients', 'action' => 'index']) ?></li>
        <li><?= $this->Html->link(__('New Ingredient'), ['controller' => 'Ingredients', 'action' => 'add']) ?></li>
    </ul>
</div>
<div class="recipes index large-10 medium-9 columns">
    <table cellpadding="0" cellspacing="0">
    <thead>
        <tr>
            <th><?= $this->Paginator->sort('id') ?></th>
            <th><?= $this->Paginator->sort('photo') ?></th>
            <th><?= $this->Paginator->sort('serves') ?></th>
            <th><?= $this->Paginator->sort('source_id') ?></th>
            <th><?= $this->Paginator->sort('title') ?></th>
            <th><?= $this->Paginator->sort('created') ?></th>
            <th><?= $this->Paginator->sort('archived') ?></th>
            <th class="actions"><?= __('Actions') ?></th>
        </tr>
    </thead>
    <tbody>
    <?php foreach ($recipes as $recipe): ?>
        <tr>
            <td><?= $this->Number->format($recipe->id) ?></td>
            <td><?= h($recipe->photo) ?></td>
            <td><?= h($recipe->serves) ?></td>
            <td>
                <?= $recipe->has('source') ? $this->Html->link($recipe->source->name, ['controller' => 'Sources', 'action' => 'view', $recipe->source->id]) : '' ?>
            </td>
            <td><?= h($recipe->title) ?></td>
            <td><?= h($recipe->created) ?></td>
            <td><?= h($recipe->archived) ?></td>
            <td class="actions">
                <?= $this->Html->link(__('View'), ['action' => 'view', $recipe->id]) ?>
                <?= $this->Html->link(__('Edit'), ['action' => 'edit', $recipe->id]) ?>
                <?= $this->Form->postLink(__('Delete'), ['action' => 'delete', $recipe->id], ['confirm' => __('Are you sure you want to delete # {0}?', $recipe->id)]) ?>
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
