module DashboardHelper
  
  def to_query(params)
    params.keys.map{|k| "#{CGI::escape(k.to_s)}=#{CGI::escape(params[k].to_s)}"}.join("&")
  end
end
