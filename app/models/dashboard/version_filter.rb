class Dashboard::VersionFilter < Dashboard::Filter

  def initialize
    super(:version)
  end

  def scope(scope)
    value == :all ? scope : scope.where(:fixed_version_id => value)
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
    else
      self.value = version.to_i if board.project.versions.where(:id => version.to_i).any?
    end
  end

  def title
    if value == :all
      I18n.t(:dashboard_all_versions)
    else
      values.map {|id| @board.project.versions.find(id) }.map(&:name).join(', ')
    end
  end

  def to_options
    [
      [[I18n.t(:dashboard_all_versions), :all]],
      @board.project.versions.open.map{|version| [version.name, version.id] },
      @board.project.versions.where('status != ?', 'open').map{|version| [version.name, version.id] }
    ]
  end
end
