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
	};

	$.fn.rdbIssueId = function() {
		return $(this).rdbIssue().data('rdb-issue-id');
	};

	$.fn.rdbIssueLockVersion = function() {
		return $(this).rdbIssue().data('rdb-lock-version');
	};

	$.fn.rdbError = function(message) {
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

	$.fn.rdbStorageAdd = function(id, value) {
		var storage = $.totalStorage('rdb-' + id);
		if(!storage) storage = new Array;
		storage.push(value);
		$.totalStorage('rdb-' + id, storage);
		return true;
	};

	$.fn.rdbStorageRemove = function(id, value) {
		var storage = $.totalStorage('rdb-' + id);
		if(!storage) return false;
		for(var i in storage) {
			if(storage[i] == value) {
				storage.splice(i, 1);
				break;
			}
		}
		$.totalStorage('rdb-' + id, storage);
		return true;
	};

	$.fn.rdbStorageHas = function(id, value) {
		var storage = $.totalStorage('rdb-' + id);
		if(!storage) return false;
		for(var i in storage) {
			if(storage[i] == value) {
				return true;
			}
		}
		return false;
	};

	/*
	 * Ajax Filter / Options
	 */
	$(document).click(function(e) {
		var link = $(e.target).rdbFindUp('a').first();
		if(link.rdbFindUp('.rdb-async').rdbAny() && link.attr('href') != '#' && !link.is('.rdb-sync')) {
			$().rdbMenuClose();
			$().rdbCloseDialog();
			e.preventDefault();
			$.getScript(
				link.attr('href')
			).fail(function(jqxhr, settings, exception) {
				link.rdbError('<b>Ajax Error</b>: ' + exception);
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

		$().rdbInit(resizeActions);
		$(window).resize(resizeActions);

		$('#rdb').rdbInit();
	});

})(jQuery);;
