(function($) {

	var rdbInits = [];

	$.fn.rdbAny = function(selector) {
		return $(this).length > 0;
	};

	$.fn.rdbEmpty = function(selector) {
		return $(this).length == 0;
	};

	$.fn.rdbFindUp = function(selector) {
		var el = $(this);
		if(el.is(selector))
			return $(this);
		return el.parents(selector);
	};

	$.fn.rdbInit = function(fn) {
		if(fn) {
			rdbInits.push(fn);
		} else {
			for(var i in rdbInits) {
				rdbInits[i].call(this);
			}
		}
	};

	$.fn.rdbIssue = function() {
		return $(this).rdbFindUp('[data-rdb-issue-id]');
	}

	$.fn.rdbIssueId = function() {
		return $(this).rdbIssue().data('rdb-issue-id');
	}

	/*
	 * Ajax Filter / Options
	 */
	$(document).ready(function() {
		$(document).click(function(e) {
			var link = $(e.target).rdbFindUp('a').first();
			if(link.rdbFindUp('.rdb-async').rdbAny() && link.attr('href') != '#' && !link.is('.rdb-sync')) {
				e.preventDefault();
				$.getScript(link.attr('href'));
			}
		});
	})

	/* Issue subject text ellipsis */
	$(document).ready(function () {
		$().rdbInit(function() {
			$('.rdb-property-subject').ellipsis();
		});

		$(window).resize(function() {
			$('.rdb-property-subject').ellipsis();
		});

		$('#rdb').rdbInit();
	});

})(jQuery);;
