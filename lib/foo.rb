class Base
  def x
    puts "x is defined in Base."
  end
end

module M
  def self.included(base)
    base.class_eval do
      def self.already_defined?(method)
        result = self.instance_methods.include?(method)
        puts "#{method} defined in #{self}: #{result}"
        result
      end

      def x
        puts "x is defined in M."
      end unless already_defined?(:x)

      def y
        puts "y is defined in M."
      end unless already_defined?(:y)
    end
  end
end

class Base
  include M
end

class Derived < Base
  include M
end

b = Base.new
b.x
b.y

d = Derived.new
d.x
d.y
