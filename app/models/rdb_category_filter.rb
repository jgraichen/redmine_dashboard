class RdbCategoryFilter < RdbFilter

  def initialize
    super :category
  end

  def scope(scope)
    return scope if all?
    scope.where :category_id => values
  end

  def all?
    values.count >= board.issue_categories.count or board.issue_categories.empty?
  end

  def default_values
    board.issue_categories.pluck(:id)
  end

  def valid_value?(value)
    default_values.include? value.to_i
  end

  def update(params)
    return unless category = params[:category]

    if category == 'all'
      self.values = board.issue_categories.pluck(:id)
    else
      id = category.to_i
      if params[:only]
        self.value = id
      else
        if values.include? id
          self.values.delete id if values.count > 2
        else
          self.values << id if valid_value?(id)
        end
      end
    end
  end

  def title
    return I18n.t(:rdb_filter_category_all) if all?
    return I18n.t(:rdb_filter_category_multiple) if values.count > 1
    board.issue_categories.find_by_id(value).try(:name)
  end

  def enabled?(id)
    return true if value == :all
    values.include? id
  end
end
