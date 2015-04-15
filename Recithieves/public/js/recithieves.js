var Recithieves, recithieves;

$(function() {
	Recithieves = function() {
		var ctxt = this;
		this.tmpl = {};
		
		$('[id]').each(function(i, e) {
			var $e = $(e);
			ctxt['$' + $e.attr('id')] = $e;
		});
		
		$('.mtmpl').each(function(i, e) {
			var $e = $(e);
			ctxt.tmpl[$e.attr('id')] = $e.html();
		});
		
		this.$searchButton.click(function(e) {
			var term = ctxt.$searchTerm.val();
			var template = ctxt.tmpl.resultsEntry;
			
			$.getJSON('/api/search/cooks/' + term, {}, function(d, s, x) {
				console.log(d);
				$.each(d, function(i, r) {
					ctxt.$resultsList.append(Mustache.render(template, r));
				});
			});
		});
		
		$('body').on('click', '.actionable', function(e) {
			var $this = $(this);
			var id = $this.data('id');
			var action = $this.data('action');
			console.log(id, action);
			ctxt[action](id);
			e.preventDefault();
		});
		
		this.showRecipe = function(id) {
			$.getJSON('/api/fetch/cooks/' + id, {}, function(d, s, x) {
				console.log(d);
			});
		};
	};
	
	recithieves = new Recithieves();
});