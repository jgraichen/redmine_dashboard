(function($) {

	$.fn.rdbColumn = function() {
		return $(this).rdbFindUp('[data-rdb-column-id]');
	};

	$.fn.rdbColumnId = function() {
		return $(this).rdbColumn().data('rdb-column-id');
	};

	/* ====================================================
	** Drag and drop
	*/
	(function($) {

		$.fn.rdbInitDAD = function () {
			var el = $(this);
			el.find(".rdb-issue").each(function() {
				var issue = $(this);

				issue.draggable('destroy');

				issue.draggable({
					revert: true,
					cursorAt: { left: Math.floor(issue.width() / 2) },
					containment: '#rdb-board',
					start: function() { $(this).addClass('rdb-issue-dragged'); },
					stop: function() { $(this).removeClass('rdb-issue-dragged'); }
				});
			});

			el.find(".rdb-column").each(function() {
				var column = $(this);
				var coluid = column.rdbColumnId();
				var accept = column.data('rdb-drop-accept');
				if(coluid && accept) {
					column.droppable({
						accept: '[data-rdb-drop-on="' + accept + '"]',
						activeClass: "rdb-column-drop-active",
						hoverClass: "rdb-column-drop-hover",
						drop: function(event, ui) {
							var issue = $(ui.draggable).rdbIssue();
							var id = issue.rdbIssueId();

							if(id && issue.rdbColumnId() != coluid) {
								issue.appendTo(column);
								issue.remove();
								issue.css({ position: 'static' });
								$.getScript('?issue=' + id + '&column=' + coluid);
							}
						}
					});
				}
			});
		};

		$.fn.rdbDestroyDAD = function () {
			$(this).find(".rdb-issue").draggable('destroy');
		};

		$().rdbInit(function() {
			$(this).rdbInitDAD();
		});

	})(jQuery);

})(jQuery);;
