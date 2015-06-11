#
module RdbRequestHelpers
  def set_permissions
    role = Role.where(name: 'Manager').first
    role.permissions << :enable_dashboards
    role.save!

    role = Role.where(name: 'Developer').first
    role.permissions << :enable_dashboards
    role.save!
    # puts role.inspect
  end

  def enable_plugin(project)
    project.enable_module! 'issue_tracking'
    project.enable_module! 'dashboard'
    project.save!
  end

  def login_as(user, password)
    visit url_for(controller: 'account', action: 'login', only_path: true)
    fill_in 'username', with: user
    fill_in 'password', with: password
    page.find(:xpath, '//input[@name="login"]').click
    @user = User.find_by_login(user)
  end

  def login_as_user
    login_as('jsmith', 'jsmith')
  end

  def login_as_admin
    login_as('admin', 'admin')
  end

  def m_select(name)
    open :xpath, "//*[contains(concat(' ', @class, ' '), ' m-select ')][contains(., '#{name}')]" do
      yield
    end
  end

  def board_title
    find :xpath, "//*[@id = 'rdb-menu']/span"
  end

  def open(*selector)
    link = find *selector

    controls = link[:'aria-controls']
    haspopup = link[:'aria-haspopup'] == 'true'
    expanded = link[:'aria-expanded'] == 'true'

    if !haspopup
      raise "Cannot open '#{selector}': Missing aria-haspopup."
    elsif controls.empty?
      raise "Cannot open '#{selector}': Empty or missing aria-controls."
    end

    link.click if !expanded
    page.assert_selector "##{controls}"

    within("##{controls}") { yield }
  end
end
