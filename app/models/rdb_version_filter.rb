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
    board.versions.where(:id => value.to_i).any?
  end

  def default_values
    if RdbDashboard.defaults[:version] == :latest
      version = board.versions.where(:status => [:open, :locked]).where('effective_date IS NOT NULL').order('effective_date ASC').first
      return [ version.id ] unless version.nil?

      version = board.versions.where(:status => [:open, :locked]).order('name ASC').first
      return [ version.id ] unless version.nil?
    end

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
      values.map {|id| board.versions.find(id) }.map(&:name).join(', ')
    end
  end

  def versions
    board.versions.where(:status => [:open, :locked])
  end

  def done_versions
    board.versions.where(:status => :closed)
  end
end
