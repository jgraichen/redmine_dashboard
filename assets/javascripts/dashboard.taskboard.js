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

	$.fn.rdbDADShowIssue = function() {
		if(currentIssue) currentIssue.css({ visibility: 'visible', opacity: 1 });
	};

	$.fn.rdbInitDAD = function () {
		var el = $(this);
		var baseURL = $('#rdb').data('rdb-base');

		el.find(".rdb-issue-drag").each(function() {
			var issue = $(this);

			issue.draggable({
				scroll: false,
				revert: true,
				// containment: '#rdb-board',
				distance: 20,
				start: function() {
					$().rdbMenuClose();
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
			var accept = column.data('rdb-drop-accept');
			if(coluid && accept) {
				column.droppable({
					accept: '[data-rdb-drop-on="' + accept + '"]',
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

	$.fn.rdbDestroyDAD = function () {
		$(this).find(".rdb-issue-drag").draggable('destroy');
	};

	$().rdbInit(function() {
		$(this).rdbInitDAD();
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
				group.rdbStorageRemove('collapsed-groups', group.rdbGroupId());
				group.removeClass('rdb-collapsed');
			} else {
				group.rdbStorageAdd('collapsed-groups', group.rdbGroupId());
				group.addClass('rdb-collapsed');
			}
		}
	});

	$().rdbInit(function() {
		$('.rdb-group').each(function() {
			var group = $(this);
			if(group.rdbStorageHas('collapsed-groups', group.rdbGroupId())) {
				group.addClass('rdb-collapsed');
			}
		});
	});

})(jQuery);;
