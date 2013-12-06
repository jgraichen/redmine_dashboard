class RdbVersionFilter < RdbFilter

  def initialize
    super :version
  end

  def scope(issues)
    case value
    when :all then issues
    when :unassigned then issues.where :fixed_version_id => nil
    else issues.where :fixed_version_id => value
    end
  end

  def valid_value?(value)
    return true if value == :all or value.nil?
    return false unless value.respond_to?(:to_i)
    board.project.versions.where(:id => value.to_i).any?
  end

  def default_values
    version = @board.project.versions.where(:status => [:open, :locked]).find(:first, :order => 'effective_date ASC', :conditions => 'effective_date IS NOT NULL')
    return [ version.id ] unless version.nil?

    version = @board.project.versions.where(:status => [:open, :locked]).find(:first, :order => 'name ASC')
    return [ version.id ] unless version.nil?

    [ :all ]
  end

  def update(params)
    return unless (version = params[:version])

    if version == 'all'
      self.value = :all
    elsif version == 'unassigned'
      self.values = [ nil ]
    else
      self.value = version.to_i
    end
  end

  def title
    if value == :all
      I18n.t(:rdb_filter_version_all)
    elsif value.nil?
      I18n.t(:rdb_filter_version_unassigned)
    else
      values.map {|id| @board.project.versions.find(id) }.map(&:name).join(', ')
    end
  end

  def versions
    @board.project.versions.where(:status => [:open, :locked])
  end

  def done_versions
    @board.project.versions.where(:status => :closed)
  end
end
