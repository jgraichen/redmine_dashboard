module NodeFixes
  def send_keys(*args)
    native.send_keys(*args)
  end

  def fill(value)
    click

    keys = [:end]
    self.value.length.times{ keys << :backspace }

    send_keys(*keys, value)

    Capybara.find('body').click
  end
end

Capybara::Node::Base.send :include, NodeFixes
