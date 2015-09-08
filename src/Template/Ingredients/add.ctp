<div class="actions columns large-2 medium-3">
    <h3><?= __('Actions') ?></h3>
    <ul class="side-nav">
        <li><?= $this->Html->link(__('List Ingredients'), ['action' => 'index']) ?></li>
        <li><?= $this->Html->link(__('List Recipes'), ['controller' => 'Recipes', 'action' => 'index']) ?></li>
        <li><?= $this->Html->link(__('New Recipe'), ['controller' => 'Recipes', 'action' => 'add']) ?></li>
    </ul>
</div>
<div class="ingredients form large-10 medium-9 columns">
    <?= $this->Form->create($ingredient) ?>
    <fieldset>
        <legend><?= __('Add Ingredient') ?></legend>
        <?php
            echo $this->Form->input('name');
            echo $this->Form->input('qty');
            echo $this->Form->input('recipe_id', ['options' => $recipes, 'empty' => true]);
            echo $this->Form->input('unit');
            echo $this->Form->input('archived');
        ?>
    </fieldset>
    <?= $this->Form->button(__('Submit')) ?>
    <?= $this->Form->end() ?>
</div>
