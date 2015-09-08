<div class="actions columns large-2 medium-3">
    <h3><?= __('Actions') ?></h3>
    <ul class="side-nav">
        <li><?= $this->Html->link(__('Edit Recipe'), ['action' => 'edit', $recipe->id]) ?> </li>
        <li><?= $this->Form->postLink(__('Delete Recipe'), ['action' => 'delete', $recipe->id], ['confirm' => __('Are you sure you want to delete # {0}?', $recipe->id)]) ?> </li>
        <li><?= $this->Html->link(__('List Recipes'), ['action' => 'index']) ?> </li>
        <li><?= $this->Html->link(__('New Recipe'), ['action' => 'add']) ?> </li>
        <li><?= $this->Html->link(__('List Sources'), ['controller' => 'Sources', 'action' => 'index']) ?> </li>
        <li><?= $this->Html->link(__('New Source'), ['controller' => 'Sources', 'action' => 'add']) ?> </li>
        <li><?= $this->Html->link(__('List Ingredients'), ['controller' => 'Ingredients', 'action' => 'index']) ?> </li>
        <li><?= $this->Html->link(__('New Ingredient'), ['controller' => 'Ingredients', 'action' => 'add']) ?> </li>
    </ul>
</div>
<div class="recipes view large-10 medium-9 columns">
    <h2><?= h($recipe->title) ?></h2>
    <div class="row">
        <div class="large-5 columns strings">
            <h6 class="subheader"><?= __('Photo') ?></h6>
            <p><?= h($recipe->photo) ?></p>
            <h6 class="subheader"><?= __('Serves') ?></h6>
            <p><?= h($recipe->serves) ?></p>
            <h6 class="subheader"><?= __('Source') ?></h6>
            <p><?= $recipe->has('source') ? $this->Html->link($recipe->source->name, ['controller' => 'Sources', 'action' => 'view', $recipe->source->id]) : '' ?></p>
            <h6 class="subheader"><?= __('Title') ?></h6>
            <p><?= h($recipe->title) ?></p>
        </div>
        <div class="large-2 columns numbers end">
            <h6 class="subheader"><?= __('Id') ?></h6>
            <p><?= $this->Number->format($recipe->id) ?></p>
        </div>
        <div class="large-2 columns dates end">
            <h6 class="subheader"><?= __('Created') ?></h6>
            <p><?= h($recipe->created) ?></p>
            <h6 class="subheader"><?= __('Modified') ?></h6>
            <p><?= h($recipe->modified) ?></p>
        </div>
        <div class="large-2 columns booleans end">
            <h6 class="subheader"><?= __('Archived') ?></h6>
            <p><?= $recipe->archived ? __('Yes') : __('No'); ?></p>
        </div>
    </div>
    <div class="row texts">
        <div class="columns large-9">
            <h6 class="subheader"><?= __('Description') ?></h6>
            <?= $this->Text->autoParagraph(h($recipe->description)) ?>
        </div>
    </div>
    <div class="row texts">
        <div class="columns large-9">
            <h6 class="subheader"><?= __('Directions') ?></h6>
            <?= $this->Text->autoParagraph(h($recipe->directions)) ?>
        </div>
    </div>
</div>
<div class="related row">
    <div class="column large-12">
    <h4 class="subheader"><?= __('Related Ingredients') ?></h4>
    <?php if (!empty($recipe->ingredients)): ?>
    <table cellpadding="0" cellspacing="0">
        <tr>
            <th><?= __('Id') ?></th>
            <th><?= __('Name') ?></th>
            <th><?= __('Qty') ?></th>
            <th><?= __('Recipe Id') ?></th>
            <th><?= __('Unit') ?></th>
            <th><?= __('Created') ?></th>
            <th><?= __('Archived') ?></th>
            <th><?= __('Modified') ?></th>
            <th class="actions"><?= __('Actions') ?></th>
        </tr>
        <?php foreach ($recipe->ingredients as $ingredients): ?>
        <tr>
            <td><?= h($ingredients->id) ?></td>
            <td><?= h($ingredients->name) ?></td>
            <td><?= h($ingredients->qty) ?></td>
            <td><?= h($ingredients->recipe_id) ?></td>
            <td><?= h($ingredients->unit) ?></td>
            <td><?= h($ingredients->created) ?></td>
            <td><?= h($ingredients->archived) ?></td>
            <td><?= h($ingredients->modified) ?></td>

            <td class="actions">
                <?= $this->Html->link(__('View'), ['controller' => 'Ingredients', 'action' => 'view', $ingredients->id]) ?>

                <?= $this->Html->link(__('Edit'), ['controller' => 'Ingredients', 'action' => 'edit', $ingredients->id]) ?>

                <?= $this->Form->postLink(__('Delete'), ['controller' => 'Ingredients', 'action' => 'delete', $ingredients->id], ['confirm' => __('Are you sure you want to delete # {0}?', $ingredients->id)]) ?>

            </td>
        </tr>

        <?php endforeach; ?>
    </table>
    <?php endif; ?>
    </div>
</div>
