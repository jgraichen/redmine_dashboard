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

	Rdb.rdbMenuClose = function() {
		if(lastMenu != null) {
			lastMenu.rdbMenuHide();
			lastMenu = null;
		}
	}

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

	/* =====================================================
	** Dashboard Dialog
	*/

	$.fn.rdbDialog = function(title, html) {
		var dialog = $('<div class="rdb-dialog" />').html(html).dialog({
			title: title,
			modal: true,
			draggable: false,
			resizable: false,
			dialogClass: 'alert',
			close: function() { Rdb.rdbDADShowIssue(); }
		});
	};

	Rdb.rdbCloseDialog = function() {
		$('.rdb-dialog').remove();
	};

	/* =====================================================
	** Dashboard Fullscreen
	*/

	Rdb.rdbIsFullscreen = function() {
		return Rdb.rdbStorageHas('fullscreen', 'fullscreen');
	};

	Rdb.rdbLoadFullscreen = function() {
		if(Rdb.rdbIsFullscreen()) {
			Rdb.rdbShowFullscreen();
		} else {
			Rdb.rdbHideFullscreen();
		}
	};

	Rdb.rdbToggleFullscreen = function() {
		Rdb.rdbMenuClose();
		if(Rdb.rdbIsFullscreen()) {
			Rdb.rdbHideFullscreen();
		} else {
			Rdb.rdbShowFullscreen();
		}
	};

	Rdb.rdbShowFullscreen = function() {
		Rdb.rdbStorageAdd('fullscreen', 'fullscreen');
		Rdb.rdbBase().addClass('rdb-fullscreen');
	};

	Rdb.rdbHideFullscreen = function() {
		Rdb.rdbStorageRemove('fullscreen', 'fullscreen');
		Rdb.rdbBase().removeClass('rdb-fullscreen');
	};

	Rdb.rdbInit(Rdb.rdbLoadFullscreen);

})(jQuery);
