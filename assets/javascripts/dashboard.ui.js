(function($) {

	$.fn.rdbMenu = function() {
		$(this).rdbFindUp('.rdb-menu');
	}

	$.fn.rdbMenuShow = function() {
		$(this).addClass('rdb-menu-active');
	}

	$.fn.rdbMenuHide = function() {
		$(this).removeClass('rdb-menu-active');
	}

	/* =====================================================
	** Dashboard Drop-Down Menus
	*/
	var lastMenu;

	$(document).click(function(e) {
		var link = $(e.target).rdbFindUp('a.rdb-menu-link');
		if(link.rdbAny() && link.parents('.rdb-menu-container').rdbEmpty() ) {
			e.preventDefault();
			var menu = link.parents('.rdb-menu').first();
			if(menu.rdbAny()) {
				if(menu.is(lastMenu)) {
					lastMenu.rdbMenuHide();
					lastMenu = null;
				} else {
					if(lastMenu) lastMenu.rdbMenuHide();
					lastMenu = menu;
					lastMenu.rdbMenuShow();
				}
			}
		}

		if(lastMenu != null && $(e.target).rdbFindUp('.rdb-menu').length == 0) {
			lastMenu.rdbMenuHide();
			lastMenu = null;
		}
	});

})(jQuery);
