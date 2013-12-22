(function(global, $) {

	global.Rdb = {};
	var rdbInits = [];

	/* extend */
	String.prototype.startsWith = function (string) {
	    return(this.indexOf(string) === 0);
	};

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

	Rdb.rdbInit = function(fn) {
		$.fn.rdbInit.call(Rdb.rdbBase(), fn);
	}

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
	};

	$.fn.rdbIssueId = function() {
		return $(this).rdbIssue().data('rdb-issue-id');
	};

	$.fn.rdbIssueLockVersion = function() {
		return $(this).rdbIssue().data('rdb-lock-version');
	};

	Rdb.rdbError = function(message) {
		var box = $('#rdb-errors');
		var msg = $('<div class="rdb-error" />').html(message).hide();

		msg.append('<a class="close">❌</a>')

		msg.find('a.close').click(function(e) {
			e.preventDefault();
			msg.fadeOut(function() {
				msg.remove();
			});
		});

		msg.appendTo(box).fadeIn(function() {
			setTimeout(function() {
				msg.fadeOut(function() {
					msg.remove();
				});
			}, 12000);
		});
	};

	$.fn.rdbVisible = function() {
		var el = $(this);
		var docTop = $(window).scrollTop();
		var docBottom = docTop + $(window).height();

		var top = $(el).offset().top;
		var bottom = top + $(el).height();

		return ((bottom <= docBottom) && (top >= docTop));
	};

	Rdb.rdbStorageAdd = function(id, value) {
		var storage = $.totalStorage('rdb-' + id);
		if(!storage) storage = new Array;
		storage.push(value);
		$.totalStorage('rdb-' + id, storage);
		return true;
	};

	Rdb.rdbStorageRemove = function(id, value) {
		var storage = $.totalStorage('rdb-' + id);
		if(!storage) return false;
		var i = -1;
		while((i = storage.indexOf(value)) >= 0) {
			storage.splice(i, 1)
		}
		$.totalStorage('rdb-' + id, storage);
		return true;
	};

	Rdb.rdbStorageHas = function(id, value) {
		var storage = $.totalStorage('rdb-' + id);
		if(!storage) return false;
		for(var i in storage) {
			if(storage[i] == value) {
				return true;
			}
		}
		return false;
	};

	Rdb.rdbBase = function() {
		return $('#rdb');
	};

	Rdb.rdbBaseURL = function() {
		return Rdb.rdbBase().data('rdb-base');
	};

	/*
	 * Ajax Filter / Options
	 */
	$(document).click(function(e) {
		var link = $(e.target).rdbFindUp('a').first();
		if(link.rdbFindUp('.rdb-async').rdbAny() && link.attr('href') != '#' && !link.is('.rdb-sync') && !link.attr('href').startsWith('javascript:')) {
			Rdb.rdbMenuClose();
			Rdb.rdbCloseDialog();
			e.preventDefault();
			$.getScript(
				link.attr('href')
			).fail(function(jqxhr, settings, exception) {
				Rdb.rdbError('<b>Ajax Error</b>: ' + exception);
			});
		}
	});

	/* Issue subject text ellipsis */
	$(document).ready(function () {
		var resizeActions = function() {
			$('.rdb-property-subject').ellipsis();

			var box = $('#rdb-errors');
			var board = $('#rdb-board');
			if($('#rdb-footer').rdbVisible()) {
				box.css({ 'position': 'absolute', 'bottom': '30px' });
			} else {
				box.css({ 'position': 'fixed', 'bottom': '30px' });
			}
		};

		Rdb.rdbInit(resizeActions);
		$(window).resize(resizeActions);
	});

	/* load board on startup */
	$(document).ready(function () {
		$.getScript('?');
	});

})(window, jQuery);
(function($) {

	$.fn.rdbColumn = function() {
		return $(this).rdbFindUp('[data-rdb-column-id]');
	};

	$.fn.rdbColumnId = function() {
		return $(this).rdbColumn().data('rdb-column-id');
	};

	$.fn.rdbGroup = function() {
		return $(this).rdbFindUp('[data-rdb-group-id]');
	};

	$.fn.rdbGroupId = function() {
		return $(this).rdbGroup().data('rdb-group-id');
	};

	/* ====================================================
	** Drag and drop
	*/

	var currentIssue;

	Rdb.rdbDADShowIssue = function() {
		if(currentIssue) currentIssue.css({ visibility: 'visible', opacity: 1 });
	};

	Rdb.rdbInitDAD = function () {
		var el = Rdb.rdbBase();
		var baseURL = Rdb.rdbBaseURL();

		el.find(".rdb-issue-drag").each(function() {
			var issue = $(this);

			issue.draggable({
				scroll: false,
				revert: true,
				// containment: '#rdb-board',
				distance: 20,
				cancel: 'a,.rdb-menu',
				start: function() {
					Rdb.rdbMenuClose();
					issue.addClass('rdb-issue-dragged');
				},
				stop: function() {
					issue.removeClass('rdb-issue-dragged');
				}
			});
		});

		el.find(".rdb-column").each(function() {
			var column = $(this);
			var coluid = column.rdbColumnId();
			var cgroup = column.data('rdb-drop-group');
			if(coluid) {
				column.droppable({
					accept: function(draggable) {
						var issue = draggable.rdbIssue();
						var dropon = issue.data('rdb-drop-on') || '';
						return issue.data('rdb-drop-group') == cgroup && dropon.indexOf(coluid) >= 0;
					}, //'[data-rdb-drop-on*="' + accept + '"]',
					activeClass: "rdb-column-drop-active",
					hoverClass: "rdb-column-drop-hover",
					tolerance: "pointer",
					drop: function(event, ui) {
						var issue = $(ui.draggable).rdbIssue();
						var lock  = issue.rdbIssueLockVersion();
						var issueId = issue.rdbIssueId();
						var groupId = issue.rdbGroupId();

						if(issueId && issue.rdbColumnId() != coluid) {
							currentIssue = issue;
							currentIssue.css({ visibility: 'hidden', opacity: 0 });
							$.getScript(
								baseURL + '/move?issue=' + issueId + '&lock_version=' + lock + '&column=' + coluid + '&group=' + groupId)
							.fail(function(jqxhr, settings, exception) {
								$().rdbDADShowIssue();
								$().rdbError('<b>Ajax Error</b>: ' + exception);
							});
						}
					}
				});
			}
		});
	};

	Rdb.rdbDestroyDAD = function () {
		Rdb.rdbBase().find(".rdb-issue-drag").draggable('destroy');
	};

	Rdb.rdbInit(function() {
		Rdb.rdbInitDAD();
	});

	/* ====================================================
	** Collapse groups
	*/

	$(document).click(function (e) {
		var link  = $(e.target).rdbFindUp('a').first();
		var group = link.rdbGroup();
		if(link.rdbAny() && group.rdbAny() && link.parents().is('.rdb-group-header')) {
			e.preventDefault();
			if(group.hasClass('rdb-collapsed')) {
				Rdb.rdbStorageRemove('collapsed-groups', group.rdbGroupId());
				group.removeClass('rdb-collapsed');
			} else {
				Rdb.rdbStorageAdd('collapsed-groups', group.rdbGroupId());
				group.addClass('rdb-collapsed');
			}
		}
	});

	Rdb.rdbInit(function() {
		$('.rdb-group').each(function() {
			var group = $(this);
			if(Rdb.rdbStorageHas('collapsed-groups', group.rdbGroupId())) {
				group.addClass('rdb-collapsed');
			}
		});
	});

})(jQuery);;
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
(function() {


}).call(this);
