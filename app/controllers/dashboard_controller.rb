class DashboardController < ApplicationController
  unloadable

  before_filter :find_project, :authorize

  def update_issue(issue, attributes)
    status = IssueStatus.find_by_id(attributes[:status])
    old_status = issue.status
    old_done_ratio = issue.done_ratio
    allowed_statuses = issue.new_statuses_allowed_to(User.current)

    # check if user is allowed to change ticket status and ticket status
    # is not the same as before
    if (User.current.admin? or allowed_statuses.include?(status)) and status != old_status
      load_issue_resolutions(issue)
      resolution_field = issue_resolution_field(issue)

      issue.init_journal(User.current, attributes[:notes] || nil)

      issue.status_id = status.id
      issue.done_ratio = attributes[:done_ratio].to_i if attributes[:done_ratio]
      issue.assigned_to_id = User.current.id if @options[:change_assignee] && issue.assigned_to_id != User.current.id

      if !resolution_field.nil? and resolution_field.value != attributes[:resolution].to_s
        issue.custom_field_values = { resolution_field.custom_field.id => attributes[:resolution].to_s }
      end

      return issue.save
    end
    false
  end

private
  def load_issues
    @issues = @project.issues.to_a

    if not @options[:owner] == :all
      @issues = @issues.select { |i| i.assigned_to == User.current }
    end
    if not @options[:version].to_s == 'all'
      @issues = @issues.select { |i| i.fixed_version_id == @options[:version].to_i or (i.fixed_version_id.to_s == '' and @options[:version] == '0') }
    end
    if not @options[:tracker].to_s == 'all'
      @issues = @issues.select { |i| i.tracker_id == @options[:tracker].to_i }
    end
    if @options[:hide_done]
      @issues = @issues.select { |i| !i.status.is_closed? }
    end

    @issues = @issues.sort { |a,b| b.priority.position <=> a.priority.position }
  end

  def load_issue_resolutions(issue)
    @done_resolved = []
    resolution_field = issue_resolution_field(issue)
    return nil if resolution_field.nil?

    resolution_field.custom_field.possible_values.each do |v|
      @done_resolved << [v, v]
    end
    return @done_resolved
  end

  # TODO: Dirty method
  def issue_resolution_field(issue)
    issue.custom_field_values.each do |f|
      if f.custom_field.read_attribute(:name).downcase == 'resolution' and f.custom_field.field_format == 'list'
        return f
      end
    end
    return nil
  end

  def find_project
    @project = Project.find(params[:id])
  end

  def default_options
    { }
  end

  def session_identifier
    self.class.name.downcase
  end

  def options
    unless @options
      @default_options = default_options
      @options = @default_options.dup
      unless params[:reset]
        @options.merge!(session["dashboard_#{@project.id}_#{session_identifier}"] || {})
        @options.merge! find_options(@options) if respond_to? :find_options
        session["dashboard_#{@project.id}_#{session_identifier}"] = @options
      else
        session["dashboard_#{@project.id}_#{session_identifier}"] = nil
      end
    end
    @options
  end
end
