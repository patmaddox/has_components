class ActiveRecord::Base
  def self.has_components(component_name)
    unless methods.include?("component_types")
      class << self
        attr_reader :component_types
      end
      @component_types = []
      define_method(:component_types) { self.class.component_types }
    end
    component_types << component_name

    klass =
    [name, component_name.to_s.classify].map {|k| k.pluralize}.sort.join
    eval <<-END
      class ::#{klass} < ComponentRelation
        belongs_to :first, :class_name => "#{name}"
        belongs_to :second, :class_name => "#{component_name.to_s.classify}"
        alias_method :frame=, :first=
        alias_method :lense=, :second=
      end
    END

    has_many klass.underscore.to_sym, :foreign_key => "first_id", :class_name => klass
    has_many :seconds, :through => klass.underscore.to_sym
    alias_method component_name, :seconds
  end
end

class ComponentRelation < ActiveRecord::Base
  abstract_class
end
