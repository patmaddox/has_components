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

    relation = RelationBuilder.new(self, component_name)

    eval <<-END
      class ::#{relation.class_name} < ComponentRelation
        belongs_to :first, :class_name => "#{relation.first}"
        belongs_to :second, :class_name => "#{relation.second}"
        alias_method :frame=, :first=
        alias_method :lense=, :second=
      end
    END

    has_many relation.table, :foreign_key => "first_id", :class_name => relation.class_name
    has_many :seconds, :through => relation.table
    alias_method component_name, :seconds
  end
end

class RelationBuilder
  attr_reader :class_name, :table, :first, :second

  def initialize(from_klass, relation)
    @from_klass = from_klass
    @relation_klass = relation.to_s.classify.constantize

    @class_name = [@from_klass, @relation_klass].map {|k| k.name.pluralize }.sort.join
    @table = class_name.underscore.to_sym
    @first = [@from_klass, @relation_klass].map {|k| k.name }.min
    @second = [@from_klass, @relation_klass].map {|k| k.name }.max
  end
end

class ComponentRelation < ActiveRecord::Base
  abstract_class
end
