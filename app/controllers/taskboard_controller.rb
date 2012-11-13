class TaskboardController < DashboardController

  def index
    @backlog = nil
    @open_versions = []
    @closed_versions = []

    @project.versions.order('effective_date').each do |version|
      @backlog = version and next if not @backlog and version.name.downcase == 'backlog'

      if version.open?
        @open_versions << version
      else
        @closed_versions << version
      end
    end

    @board = Taskboard.new @project, options
  end

  def default_options
    {
      :assignee => :me,
      :version => find_version,
      :tracker => nil,
      :group => 'none',
      :change_assignee => false,
      :hide_done => false
    }
  end

  def find_options(options)
    if params[:assignee]
      if params[:assignee] == 'all' or params[:assignee] == 'me'
        options[:assignee] = params[:assignee].to_sym
      elsif @project.members.where(:id => params[:assignee].to_i).any?
        options[:assignee] = params[:assignee].to_i
      end
    end

    if params[:version]
      if params[:version] == 'all'
        options[:version] = nil
      elsif @project.versions.where(:id => params[:version]).any?
        options[:version] = params[:version].to_i
      end
    end

    if params[:tracker]
      if params[:tracker] == 'all'
        options[:tracker] = nil
      elsif @project.trackers.where(:id => params[:version]).any?
        options[:tracker] = params[:tracker].to_i
      end
    end

    options[:view] = params[:view].to_sym if params[:view] and Dashboard::VIEW_MODES.include? params[:view].to_sym
    options[:group] = params[:group] unless params[:group].nil?
    options[:change_assignee] = (params[:change_assignee] == "true" ? true : false) unless params[:change_assignee].nil?
    options[:hide_done] = (params[:hide_done] == "true" ? true : false) unless params[:hide_done].nil?
    options
  end

  def find_version
    version = @project.versions.open.find(:first, :order => 'effective_date ASC', :conditions => 'effective_date IS NOT NULL')
    return version.id unless version.nil?

    version = @project.versions.open.find(:first, :order => 'name ASC')
    return version.id unless version.nil?

    nil
  end
end
