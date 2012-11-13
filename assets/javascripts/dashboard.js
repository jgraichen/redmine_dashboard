$(document).ready(function() {

	$.fn.findAnchor = function() {
		if($(this).context)
			return $(this).context.tagName == 'A' ? $(this) : $(this).parents('a');
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
			var link = $(e.target).findAnchor();
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
			var link = $(e.target).findAnchor();
			if(link.data('dashboard') == 'async') {
				e.preventDefault();
				$.getScript(link.attr('href'));
			}
		});
	})(jQuery);
});
