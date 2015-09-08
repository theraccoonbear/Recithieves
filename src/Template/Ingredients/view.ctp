<div class="actions columns large-2 medium-3">
    <h3><?= __('Actions') ?></h3>
    <ul class="side-nav">
        <li><?= $this->Html->link(__('Edit Ingredient'), ['action' => 'edit', $ingredient->id]) ?> </li>
        <li><?= $this->Form->postLink(__('Delete Ingredient'), ['action' => 'delete', $ingredient->id], ['confirm' => __('Are you sure you want to delete # {0}?', $ingredient->id)]) ?> </li>
        <li><?= $this->Html->link(__('List Ingredients'), ['action' => 'index']) ?> </li>
        <li><?= $this->Html->link(__('New Ingredient'), ['action' => 'add']) ?> </li>
        <li><?= $this->Html->link(__('List Recipes'), ['controller' => 'Recipes', 'action' => 'index']) ?> </li>
        <li><?= $this->Html->link(__('New Recipe'), ['controller' => 'Recipes', 'action' => 'add']) ?> </li>
    </ul>
</div>
<div class="ingredients view large-10 medium-9 columns">
    <h2><?= h($ingredient->name) ?></h2>
    <div class="row">
        <div class="large-5 columns strings">
            <h6 class="subheader"><?= __('Name') ?></h6>
            <p><?= h($ingredient->name) ?></p>
            <h6 class="subheader"><?= __('Recipe') ?></h6>
            <p><?= $ingredient->has('recipe') ? $this->Html->link($ingredient->recipe->title, ['controller' => 'Recipes', 'action' => 'view', $ingredient->recipe->id]) : '' ?></p>
            <h6 class="subheader"><?= __('Unit') ?></h6>
            <p><?= h($ingredient->unit) ?></p>
        </div>
        <div class="large-2 columns numbers end">
            <h6 class="subheader"><?= __('Id') ?></h6>
            <p><?= $this->Number->format($ingredient->id) ?></p>
            <h6 class="subheader"><?= __('Qty') ?></h6>
            <p><?= $this->Number->format($ingredient->qty) ?></p>
        </div>
        <div class="large-2 columns dates end">
            <h6 class="subheader"><?= __('Created') ?></h6>
            <p><?= h($ingredient->created) ?></p>
            <h6 class="subheader"><?= __('Modified') ?></h6>
            <p><?= h($ingredient->modified) ?></p>
        </div>
        <div class="large-2 columns booleans end">
            <h6 class="subheader"><?= __('Archived') ?></h6>
            <p><?= $ingredient->archived ? __('Yes') : __('No'); ?></p>
        </div>
    </div>
</div>
