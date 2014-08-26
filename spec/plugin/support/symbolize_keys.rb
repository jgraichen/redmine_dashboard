class Array
  def deep_symbolize_keys
    map{|e| e.respond_to?(:deep_symbolize_keys) ? e.deep_symbolize_keys : e }
  end
end

class Hash
  def deep_symbolize_keys
    Hash[map{|k,v| [k.respond_to?(:to_sym) ? k.to_sym : k, v.respond_to?(:deep_symbolize_keys) ? v.deep_symbolize_keys : v]}]
  end
end
