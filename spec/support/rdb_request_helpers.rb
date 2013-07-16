
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

  def rdb_menu_item(menu, item)
    sleep 1
    within ".rdb-menu-#{menu}" do
      find('a.rdb-menu-link').click
      return find('.rdb-container').find(:xpath, ".//a[contains(text(), '#{item}')]")
    end
  end
end
