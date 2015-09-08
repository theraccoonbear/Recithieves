<div class="actions columns large-2 medium-3">
    <h3><?= __('Actions') ?></h3>
    <ul class="side-nav">
        <li><?= $this->Html->link(__('Edit Source'), ['action' => 'edit', $source->id]) ?> </li>
        <li><?= $this->Form->postLink(__('Delete Source'), ['action' => 'delete', $source->id], ['confirm' => __('Are you sure you want to delete # {0}?', $source->id)]) ?> </li>
        <li><?= $this->Html->link(__('List Sources'), ['action' => 'index']) ?> </li>
        <li><?= $this->Html->link(__('New Source'), ['action' => 'add']) ?> </li>
        <li><?= $this->Html->link(__('List Recipes'), ['controller' => 'Recipes', 'action' => 'index']) ?> </li>
        <li><?= $this->Html->link(__('New Recipe'), ['controller' => 'Recipes', 'action' => 'add']) ?> </li>
    </ul>
</div>
<div class="sources view large-10 medium-9 columns">
    <h2><?= h($source->name) ?></h2>
    <div class="row">
        <div class="large-5 columns strings">
            <h6 class="subheader"><?= __('Base Url') ?></h6>
            <p><?= h($source->base_url) ?></p>
            <h6 class="subheader"><?= __('Name') ?></h6>
            <p><?= h($source->name) ?></p>
            <h6 class="subheader"><?= __('Slug') ?></h6>
            <p><?= h($source->slug) ?></p>
        </div>
        <div class="large-2 columns numbers end">
            <h6 class="subheader"><?= __('Id') ?></h6>
            <p><?= $this->Number->format($source->id) ?></p>
        </div>
        <div class="large-2 columns dates end">
            <h6 class="subheader"><?= __('Modified') ?></h6>
            <p><?= h($source->modified) ?></p>
            <h6 class="subheader"><?= __('Created') ?></h6>
            <p><?= h($source->created) ?></p>
        </div>
        <div class="large-2 columns booleans end">
            <h6 class="subheader"><?= __('Archived') ?></h6>
            <p><?= $source->archived ? __('Yes') : __('No'); ?></p>
        </div>
    </div>
</div>
<div class="related row">
    <div class="column large-12">
    <h4 class="subheader"><?= __('Related Recipes') ?></h4>
    <?php if (!empty($source->recipes)): ?>
    <table cellpadding="0" cellspacing="0">
        <tr>
            <th><?= __('Id') ?></th>
            <th><?= __('Description') ?></th>
            <th><?= __('Directions') ?></th>
            <th><?= __('Photo') ?></th>
            <th><?= __('Serves') ?></th>
            <th><?= __('Source Id') ?></th>
            <th><?= __('Title') ?></th>
            <th><?= __('Created') ?></th>
            <th><?= __('Archived') ?></th>
            <th><?= __('Modified') ?></th>
            <th class="actions"><?= __('Actions') ?></th>
        </tr>
        <?php foreach ($source->recipes as $recipes): ?>
        <tr>
            <td><?= h($recipes->id) ?></td>
            <td><?= h($recipes->description) ?></td>
            <td><?= h($recipes->directions) ?></td>
            <td><?= h($recipes->photo) ?></td>
            <td><?= h($recipes->serves) ?></td>
            <td><?= h($recipes->source_id) ?></td>
            <td><?= h($recipes->title) ?></td>
            <td><?= h($recipes->created) ?></td>
            <td><?= h($recipes->archived) ?></td>
            <td><?= h($recipes->modified) ?></td>

            <td class="actions">
                <?= $this->Html->link(__('View'), ['controller' => 'Recipes', 'action' => 'view', $recipes->id]) ?>

                <?= $this->Html->link(__('Edit'), ['controller' => 'Recipes', 'action' => 'edit', $recipes->id]) ?>

                <?= $this->Form->postLink(__('Delete'), ['controller' => 'Recipes', 'action' => 'delete', $recipes->id], ['confirm' => __('Are you sure you want to delete # {0}?', $recipes->id)]) ?>

            </td>
        </tr>

        <?php endforeach; ?>
    </table>
    <?php endif; ?>
    </div>
</div>
