module NodeFixes
  def send_keys(*args)
    native.send_keys(*args)
  end

  def fill(value)
    click

    keys = [:end]
    self.value.length.times{ keys << :backspace }

    send_keys(*keys, value)

    driver.browser.execute_script 'arguments[0].blur()', native
  end
end

Capybara::Node::Base.send :include, NodeFixes
