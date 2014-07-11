module Rdb::Patch
  module IssuePriority

    def rdb_color
      @rdb_color ||= begin
        field = custom_field_values.find {|f| f.custom_field.read_attribute(:name).downcase == 'color' && f.to_s.present?}
        field ? field.to_s : nil
      end
    end

    def rdb_color_css
      rdb_color ? "border-color: #{rdb_color}" : ''
    end
  end
end

IssuePriority.send :include, Rdb::Patch::IssuePriority
