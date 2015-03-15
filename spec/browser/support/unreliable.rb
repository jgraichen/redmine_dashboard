module Unreliable
  def unreliable(opts = {})
    max = Integer opts.fetch(:max, 2)
    run = 0

    begin
      yield
    rescue => err
      run += 1
      if run <= max
        STDOUT.puts "Retry unreliable test... (#{run}/#{max})"
        retry
      else
        raise err
      end
    end
  end
end
