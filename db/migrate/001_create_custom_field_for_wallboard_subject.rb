class CreateCustomFieldForWallboardSubject < ActiveRecord::Migration[5.2]
  def self.up
    c = CustomField.new(
      name: 'wallboard-subject',
      editable: true,
      visible: true,
      field_format: 'string'
    )
    c.type = 'IssueCustomField'
    c.save
  end

  def self.down
    CustomField.find_by_name('wallboard-subject')&.delete
  end
end