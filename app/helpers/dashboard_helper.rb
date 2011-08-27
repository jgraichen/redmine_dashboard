module DashboardHelper
  
  def select_filter_versions
    versions = @project.versions.find(:all) || []
    versions = versions.uniq.sort
    versions_done = versions.select { |version| !version.open? }
    versions_open = versions.select { |version| version.open? && !version.effective_date.nil? }
    versions_open_wodate = versions.select { |version| version.open? && version.effective_date.nil? }
    
    versions = [['', [[l(:all_versions), 'all'], [l(:unassigned), '0']]]]
    
    if versions_open.length > 0
      versions << [l(:open), versions_open.map{|v| [v.name, v.id.to_s]}]
    end
    
    if versions_open_wodate.length > 0
      versions << [l(:open_without_date), versions_open_wodate.map{|v| [v.name, v.id.to_s]}]
    end
  
    if versions_done.length > 0
      versions << [l(:closed), versions_done.map{|v| [v.name, v.id.to_s]}]
    end
  
    options = grouped_options_for_select(versions,  @options[:version].to_s)
    
    select_tag(:version, options, :onchange => 
      remote_function(
        :update => "dashboard",
        :with   => "'version=' + value",
        :url => { :action => :index }
      )
    )
  end
end