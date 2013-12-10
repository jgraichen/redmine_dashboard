class RdbBoard < ActiveRecord::Base
  # id
  # name
  # type
  # options
  serialize :options, Hash

  belongs_to :project
  belongs_to :creator, :class_name => "User"
end
