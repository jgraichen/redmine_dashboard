module Unreliable
  def unreliable(opts = {})
    max = Integer opts.fetch(:max, 2)
    run = 1

    begin
      yield
    rescue => err
      if run <= max
        STDOUT.puts "Retry unreliable test... (#{run}/#{max})"
        retry
      else
        raise err
      end
    end
  end
end
