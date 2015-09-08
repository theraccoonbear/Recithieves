<h1>Recithieves Test</h1>
<div class="row">
    <div class="col-xs-12">
        <form id="searchForm" action="<?php echo $this->Url->build(['_name' => 'api-search', '_ext' => 'json']); ?>">
            <label for="searchTerm">Search: <input type="text" id="searchTerm"></label>
        </form>
    </div>
</div>  