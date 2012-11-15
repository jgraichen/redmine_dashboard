$(document).ready(function() {

	$.fn.findUp = function(selector) {
		var el = $(this);
		if(el.is(selector))
			return $(this);
		return el.parents(selector);
	};

	$.fn.dashboardIssueId = function() {
		return $(this).findUp('[data-dashboard-issue]').data('dashboard-issue');
	};

	/*
	 * Menus
	 */
	(function($) {
		var current;

		// $('.dashboard-menu-link').each(function() {
		// 	var self = $(this);
		// 	var menu = self.parents('.dashboard-menu').first();

		// 	if(menu) {
		// 		self.click(function() {
		// 			menu.toggleClass('dashboard-menu-active');
		// 			if(current)
		// 				current.removeClass('dashboard-menu-active');
		// 			current = menu.hasClass('dashboard-menu-active') ? menu : null;
		// 		});
		// 	}
		// });
		$(document).click(function(e) {
			var link = $(e.target).findUp('a');
			if(link) {
				var menu = link.parents('.dashboard-menu').first();
				if(menu) {
					menu.toggleClass('dashboard-menu-active');
					if(current)
						current.removeClass('dashboard-menu-active');
					current = menu.hasClass('dashboard-menu-active') ? menu : null;
				}
			}

			if(current != null && $(e.target).parents('.dashboard-menu').length == 0) {
				current.removeClass('dashboard-menu-active');
				current = null;
			}
		});
	})(jQuery);

	/*
	 * Ajax Filter / Options
	 */
	(function($) {
		$(document).click(function(e) {
			var link = $(e.target).findUp('a');
			if(link.data('dashboard') == 'async') {
				e.preventDefault();
				$.getScript(link.attr('href'));
			}
		});
	})(jQuery);

	/*
	 * Toggle parent issue visiblity
	 */
	(function($) {

		$.fn.dashboardIsHiddenChildIssues = function() {
			var el = $(this);
			return el.find('.dashboard-parent-children').first().css('display') == 'none';
		};

		$.fn.dashboardHideChildIssues = function() {
			var el = $(this);
			var id = el.dashboardIssueId();
			if(id) {
				var hiddenIssues = $.totalStorage('dashboard-hidden-parent-issues');
				if(!hiddenIssues) hiddenIssues = new Object();
				hiddenIssues[id] = true;
				$.totalStorage('dashboard-hidden-parent-issues', hiddenIssues);

				el.find('.dashboard-parent-children').first().hide();
			}
		};

		$.fn.dashboardShowChildIssues = function() {
			var el = $(this);
			var id = el.dashboardIssueId();
			if(id) {
				var hiddenIssues = $.totalStorage('dashboard-hidden-parent-issues');
				if(hiddenIssues) {
					delete hiddenIssues[id];
					$.totalStorage('dashboard-hidden-parent-issues', hiddenIssues);
				}

				el.find('.dashboard-parent-children').first().show();
			}
		};


		$.fn.dashboardInitChildIssueVisibility = function() {
			var el = $(this);
			var hiddenIssues = $.totalStorage('dashboard-hidden-parent-issues');
			if(hiddenIssues) {
				for(var id in hiddenIssues) {
					el.find('[data-dashboard-issue="' + id + '"]').dashboardHideChildIssues();
				}
			}
		};

		$(document).click(function(e) {
			var handle = $(e.target).findUp('[data-dashboard-event-tpv]');
			var issue = $('[data-dashboard-issue="' + handle.data('dashboard-event-tpv') + '"]').first();

			if(issue) {
				if(issue.dashboardIsHiddenChildIssues()) {
					issue.dashboardShowChildIssues();
				} else {
					issue.dashboardHideChildIssues();
				}
			}
		});

	})(jQuery);

	/*
	 * Drag and drop
	 */
	(function($) {

		$.fn.dashboardInitDragAndDrop = function () {
			var el = $(this);
			el.find(".dashboard-issue").each(function() {
				var issue = $(this);
				issue.draggable({
					revert: true,
					axis: "x",
					cursorAt: { top: issue.height()/2, left: issue.width()/2 },
					start: function() { $(this).addClass('dashboard-issue-dragged'); },
					stop: function() { $(this).removeClass('dashboard-issue-dragged'); }
				});
			});

			el.find(".dashboard-column").each(function() {
				var column = $(this);
				var coluid = column.data('dashboard-column-id');
				var accept = column.data('dashboard-drop-accept');
				column.droppable({
					accept: ".dashboard-drop-" + accept,
					activeClass: "dashboard-column-drop-active",
					hoverClass: "dashboard-column-drop-hover",
					drop: function(event, ui) {
						var issue = $(event.srcElement).findUp('.dashboard-issue');
						var id = issue.dashboardIssueId();

						// if(id && coluid) {
							issue.remove();
							$.getScript('?issue=' + id + '&column=' + coluid);
						// }
					}
				});
			});
		};
	})(jQuery);

	/*
	 * Init
	 */
	(function($) {
		$.fn.dashboardInit = function() {
			var el = $(this);
			el.dashboardInitChildIssueVisibility();
			el.dashboardInitDragAndDrop();
		};

		$('#dashboard-taskboard').dashboardInit();
	})(jQuery);
});
