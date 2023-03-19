# frozen_string_literal: true

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
