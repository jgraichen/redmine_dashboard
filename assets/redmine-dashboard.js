(function() {
  $.fn.isAny = function() {
    return $(this).length !== 0;
  };

  $.fn.isEmpty = function() {
    return $(this).length === 0;
  };

}).call(this);
(function() {
  jQuery(function() {
    var lastMenu;
    lastMenu = null;
    $.fn.rdbMenuOpen = function() {
      var listitem, menu, section;
      menu = $(this).closest('.rdb-menu');
      if (menu.isAny()) {
        menu.addClass('rdb-menu-active');
        section = menu.find('section').first();
        if (section.isAny()) {
          listitem = section.find('ul.rdb-menu-list li a').first();
          if (listitem.isAny()) {
            return listitem.focus();
          }
        }
      }
    };
    $(document).on('click', function(e) {
      var link, menu;
      link = $(e.target).closest('a.rdb-menu-link');
      if (link.isAny() && link.closest('.rdb-container').isEmpty()) {
        e.preventDefault();
        if ((menu = link.closest('.rdb-menu')).isAny()) {
          if (lastMenu) {
            lastMenu.removeClass('rdb-menu-active');
          }
          if (menu.is(lastMenu)) {
            lastMenu = null;
          } else {
            menu.rdbMenuOpen();
            lastMenu = menu;
          }
        }
      }
      if (lastMenu && $(e.target).closest('.rdb-menu').isEmpty()) {
        lastMenu.removeClass('rdb-menu-active');
        return lastMenu = null;
      }
    });
    return $(document).on('hover', '.rdb-menu-list > li > a', function(e) {
      return $(this).focus();
    });
  });

}).call(this);
