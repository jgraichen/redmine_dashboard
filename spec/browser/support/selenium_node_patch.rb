module SeleniumNodePatch
  def set(value)
    if tag_name == 'textarea' or tag_name == 'input'
      if self[:type] == '' or self[:type] == 'text'
        if !self[:readonly]
          native.send_keys [:control, 'a'], :backspace

          return if value.to_s.empty?
        end
      end
    end

    super
  end
end

Capybara::Selenium::Node.send :prepend, SeleniumNodePatch
