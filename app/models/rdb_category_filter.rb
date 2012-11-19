class RdbCategoryFilter < RdbFilter

  def initialize
    super :category
  end

  def filter(issues)
    return issues if all?
    issues.select{|i| i.children.any? or values.include?(i.category_id) }
  end

  def all?
    values.count == board.project.issue_categories.count
  end

  def apply_to_child_issues?
    true
  end

  def default_values
    board.project.issue_categories.pluck(:id)
  end

  def update(params)
    return unless category = params[:category]

    if category == 'all'
      self.values = board.project.issue_categories.pluck(:id)
    else
      id = category.to_i
      if board.project.issue_categories.where(:id => id).any?
        if params[:only]
          self.value = id
        else
          if values.include? id
            self.values.delete id if values.count > 2
          else
            self.values << id
          end
        end
      end
    end
  end

  def title
    return I18n.t(:rdb_filter_category_all) if all?
    return I18n.t(:rdb_filter_category_multiple) if values.count > 1
    board.project.issue_categories.find(value).name
  end

  def enabled?(id)
    return true if value == :all
    values.include? id
  end
end
