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
    puts klass
    eval <<-END
      class #{klass} < ComponentRelation
        has_many :#{component_name}
      end
    END
    has_many klass.underscore, :class_name => klass
    has_many component_name, :through => klass.underscore
  end
end

class ComponentRelation < ActiveRecord::Base
  abstract_class
end
