class RdbDashboard::VersionFilter < RdbDashboard::Filter

  def initialize
    super :version
  end

  def filter(issues)
    case value
    when :all  then issues
    when :unassigned then issues.select{|i| i.children.any? or i.fixed_version_id == nil}
    else issues.select{|i| i.children.any? or i.fixed_version_id == value }
    end
  end

  def apply_to_child_issues?
    true
  end

  def default_values
    version = @board.project.versions.open.find(:first, :order => 'effective_date ASC', :conditions => 'effective_date IS NOT NULL')
    return [ version.id ] unless version.nil?

    version = @board.project.versions.open.find(:first, :order => 'name ASC')
    return [ version.id ] unless version.nil?

    [ :all ]
  end

  def update(params)
    return unless version = params[:version]

    if version == 'all'
      self.value = :all
    elsif version == 'unassigned'
      self.value = :unassigned
    else
      self.value = version.to_i if board.project.versions.where(:id => version.to_i).any?
    end
  end

  def title
    if value == :all
      I18n.t(:rdb_filter_version_all)
    elsif value == :unassigned
      I18n.t(:rdb_filter_version_unassigned)
    else
      values.map {|id| @board.project.versions.find(id) }.map(&:name).join(', ')
    end
  end

  def versions
    @board.project.versions.open
  end

  def done_versions
    @board.project.versions.where('status != ?', 'open')
  end
end
