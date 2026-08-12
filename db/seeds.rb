# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

# -------------------------------------------------------------------
#   Users
# -------------------------------------------------------------------

User.find_or_initialize_by(login: 'admin').tap do |user|
  user.update(
    mail: 'admin@example.org',
    password: 'adminadmin',
    firstname: 'Adam',
    lastname: 'Administrator',
    admin: true,
  )

  user.save!
end

john = User.find_or_initialize_by(login: 'john').tap do |user|
  user.update(
    mail: 'john@example.org',
    password: '1234567890',
    firstname: 'John',
    lastname: 'Smith',
  )

  user.save!
end

jane = User.find_or_initialize_by(login: 'jane').tap do |user|
  user.update(
    mail: 'jane@example.org',
    password: '1234567890',
    firstname: 'Jane',
    lastname: 'Smith',
  )

  user.save!
end

alice = User.find_or_initialize_by(login: 'alice').tap do |user|
  user.update(
    mail: 'alice@example.org',
    password: '1234567890',
    firstname: 'Alice',
    lastname: 'Smith',
  )

  user.save!
end

bob = User.find_or_initialize_by(login: 'bob').tap do |user|
  user.update(
    mail: 'bob@example.org',
    password: '1234567890',
    firstname: 'Bob',
    lastname: 'Smith',
  )

  user.save!
end

carol = User.find_or_initialize_by(login: 'carol').tap do |user|
  user.update(
    mail: 'carol@example.org',
    password: '1234567890',
    firstname: 'Carol',
    lastname: 'Smith',
  )

  user.save!
end

dave = User.find_or_initialize_by(login: 'dave').tap do |user|
  user.update(
    mail: 'dave@example.org',
    password: '1234567890',
    firstname: 'Dave',
    lastname: 'Smith',
  )

  user.save!
end

eve = User.find_or_initialize_by(login: 'eve').tap do |user|
  user.update(
    mail: 'eve@example.org',
    password: '1234567890',
    firstname: 'Eve',
    lastname: 'Smith',
  )

  user.save!
end

mallory = User.find_or_initialize_by(login: 'mallory').tap do |user|
  user.update(
    mail: 'mallory@example.org',
    password: '1234567890',
    firstname: 'Mallory',
    lastname: 'Smith',
  )

  user.save!
end

oscar = User.find_or_initialize_by(login: 'oscar').tap do |user|
  user.update(
    mail: 'oscar@example.org',
    password: '1234567890',
    firstname: 'Oscar',
    lastname: 'Smith',
  )

  user.save!
end

# -------------------------------------------------------------------
#   Projects and members
# -------------------------------------------------------------------

smithcorp = Project.find_or_initialize_by(identifier: 'smithcorp').tap do |project|
  project.update(
    name: 'Smith Company',
    description: 'Text Text Text',
  )

  project.save!

  project.enable_module! 'dashboard'
end

engineering = Project.find_or_initialize_by(identifier: 'engineering').tap do |project|
  project.update(
    name: 'Engineering',
    description: 'Making things',
    parent: smithcorp,
  )

  project.save!

  project.enable_module! 'dashboard'
end

finance = Project.find_or_initialize_by(identifier: 'finance').tap do |project|
  project.update(
    name: 'Finance',
    description: 'Keeping the money',
    parent: smithcorp,
  )

  project.save!

  project.enable_module! 'dashboard'
end

management = Project.find_or_initialize_by(identifier: 'management').tap do |project|
  project.update(
    name: 'Management',
    description: 'Controlling',
    parent: smithcorp,
  )

  project.save!

  project.enable_module! 'dashboard'
end

# -------------------------------------------------------------------
#   Dashboard permissions
# -------------------------------------------------------------------

Role.where(name: 'Manager').first!.tap do |role|
  role.permissions << :view_dashboards
  role.permissions << :configure_dashboards
  role.save!
end

Role.where(name: 'Developer').first!.tap do |role|
  role.permissions << :view_dashboards
  role.save!
end

Role.where(name: 'Reporter').first!.tap do |role|
  role.permissions << :view_dashboards
  role.save!
end

# -------------------------------------------------------------------
#   Memberships and project setup
# -------------------------------------------------------------------

seed_users = [john, jane, alice, bob, carol, dave, eve, mallory, oscar]
seed_projects = [smithcorp, engineering, finance, management]

manager_role = Role.find_by(name: 'Manager')
developer_role = Role.find_by(name: 'Developer')
reporter_role = Role.find_by(name: 'Reporter')

seed_projects.each do |project|
  # Make sure all available trackers are enabled for broad demo coverage.
  missing_trackers = Tracker.sorted.to_a - project.trackers.to_a
  project.trackers << missing_trackers if missing_trackers.any?

  seed_users.each do |user|
    member = Member.find_or_initialize_by(project: project, user: user)
    member_roles = member.roles.to_a

    if user == john && manager_role
      member_roles << manager_role
    elsif user == jane && reporter_role
      member_roles << reporter_role
    elsif developer_role
      member_roles << developer_role
    end

    member.roles = member_roles.uniq
    member.save!
  end
end

# -------------------------------------------------------------------
#   Categories ("components") and versions
# -------------------------------------------------------------------

project_components = {
  'smithcorp' => %w[Operations Infrastructure Security Compliance],
  'engineering' => %w[Backend Frontend Data QA],
  'finance' => %w[Accounting Billing Forecasting Auditing],
  'management' => %w[Planning Roadmap People Process]
}.freeze

version_data = [
  {name: '1.0', months: -2, status: 'closed'},
  {name: '1.1', months: 1, status: 'open'},
  {name: '2.0', months: 3, status: 'open'}
].freeze

seed_projects.each do |project|
  component_names = project_components.fetch(project.identifier, ['General'])
  component_names.each do |name|
    IssueCategory.find_or_create_by!(project: project, name: name)
  end

  version_data.each do |version_data|
    Version.find_or_initialize_by(project: project, name: version_data[:name]).tap do |version|
      version.status = version_data[:status]
      version.effective_date = Date.current >> version_data[:months]
      version.description = "Seeded demo version #{version_data[:name]} for #{project.name}"
      version.save!
    end
  end
end

# Set deterministic sample colors for priorities in dashboard cards.
priority_palette = %w[gray-300 green-400 yellow-300 orange-400 red-400 blue-400]
IssuePriority.sorted.each_with_index do |priority, index|
  color = priority_palette[index % priority_palette.length]
  priority.update!(dashboard_color: color)
end

# -------------------------------------------------------------------
#   Issues for dashboard demo data
# -------------------------------------------------------------------

trackers = Tracker.sorted.to_a
statuses = IssueStatus.sorted.to_a
priorities = IssuePriority.sorted.to_a
reference_date = Date.current

seed_projects.each do |project|
  categories = project.issue_categories.order(:name).to_a
  # Redmine validates fixed_version against issue.assignable_versions,
  # which uses project.shared_versions.open.
  versions = project.shared_versions.open.sorted.to_a

  seed_users.each_with_index do |author, author_index|
    priorities.each_with_index do |priority, priority_index|
      issue_number = (author_index * priorities.size) + priority_index + 1
      status = statuses[(author_index + priority_index) % statuses.size]
      assignee = if issue_number % 5 == 0
                   nil
                 else
                   seed_users[(author_index + priority_index + 1) % seed_users.size]
                 end
      category = (issue_number % 4).zero? ? nil : categories[(issue_number - 1) % categories.size]
      version = if versions.any? && (issue_number % 3) != 0
                  versions[(issue_number - 1) % versions.size]
                end
      tracker = trackers[(issue_number - 1) % trackers.size]
      start_date = reference_date - ((issue_number % 30) + 1)
      due_date = start_date + ((issue_number % 12) + 3)

      subject = "[Seed][#{project.identifier}] #{author.login.capitalize} #{priority.name} #{issue_number}"

      Issue.find_or_initialize_by(project: project, subject: subject).tap do |issue|
        issue.author = author
        issue.assigned_to = assignee
        issue.priority = priority
        issue.tracker = tracker
        issue.status = status
        issue.category = category
        issue.fixed_version = version
        issue.start_date = start_date
        issue.due_date = due_date
        issue.estimated_hours = ((issue_number % 8) + 1) * 2
        issue.done_ratio = if status.is_closed?
                             100
                           elsif status.position <= 2
                             (issue_number % 4) * 10
                           else
                             40 + ((issue_number % 6) * 10)
                           end
        issue.description = [
          "Seeded dashboard demo issue for #{project.name}.",
          "Author: #{author.name}",
          "Assignee: #{assignee&.name || 'Unassigned'}",
          "Priority: #{priority.name}",
          "Tracker: #{tracker.name}",
          "Component: #{category&.name || 'Unassigned'}",
          "Version: #{version&.name || 'Unassigned'}"
        ].join("\n")

        issue.save!
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
