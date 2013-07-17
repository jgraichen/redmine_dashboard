
module RdbRequestHelpers

  def set_permissions
    role = Role.where(:name => 'Manager').first
    role.permissions << :view_dashboards
    role.permissions << :configure_dashboards
    role.save!

    role = Role.where(:name => 'Developer').first
    role.permissions << :view_dashboards
    role.save!
    # puts role.inspect
  end

  def login_as(user, password)
    visit url_for(:controller => 'account', :action => 'login', :only_path => true)
    fill_in 'username', :with => user
    fill_in 'password', :with => password
    page.find(:xpath, '//input[@name="login"]').click
    @user = User.find_by_login(user)
  end

  def login_as_user
    login_as('jsmith', 'jsmith')
  end

  def login_as_admin
    login_as('admin', 'admin')
  end

  # Renders an image of current page with poltergeist.
  def render_image(name)
    page.driver.render("../../screenshot-#{name}.png", :full => true)
  end

  def select_filter(filter, value)
    find_menu_link(filter).click
    find_menu_container(filter).click_link value
    find_menu_link(filter).should have_content(value)
  end

  def unset_all_filter
    select_filter :versions, 'All Versions'
    select_filter :assignee, 'All Assignees'
  end

  def find_menu(id)
    find(:xpath, "//*[contains(@class, \"rdb-menu-#{id}\")]")
  end

  def find_menu_link(id)
    find_menu(id).find('.rdb-menu-link')
  end

  def find_menu_container(id)
    find_menu(id).find('.rdb-container')
  end

  def find_menu_item(id, item)
    find_menu_container(id).find(:xpath, ".//a[contains(text(), '#{item}')]")
  end
end
