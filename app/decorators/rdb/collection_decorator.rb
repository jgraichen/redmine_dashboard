# = CollectionDecorator
#
# The {CollectionDecorator} wraps a collection - an array, or
# ActiveRecord::Relation - and decorates each item using the given decorator
# class when iterating over the collection.
#
class Rdb::CollectionDecorator
  include Enumerable

  def initialize(collection, decorator_class)
    @collection = collection
    @decorator_class = decorator_class
  end

  def each
    if block_given?
      @collection.each{|item| yield @decorator_class.new(item) }
    else
      Kernel.to_enum(&:each)
    end
  end
end
