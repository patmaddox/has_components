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
        belongs_to :first, :class_name => "#{relation.first_class}"
        belongs_to :second, :class_name => "#{relation.second_class}"
        alias_method :#{relation.first}=, :first=
        alias_method :#{relation.second}=, :second=
      end
    END

    has_many relation.table, :foreign_key => relation.foreign_key, :class_name => relation.class_name
    has_many relation.source, :through => relation.table
    alias_method component_name, relation.source
  end
end

module HasComponents
  module Validations
    def validates_component(component, options={ })
      through_list = [options[:through]].flatten
      validates_each(component) do |record, attr, value|
        through_list.each do |through|
          if record.send(component) && record.send(through) &&
              record.send(through).send(component.to_s.pluralize).find_by_id(record.send(component).id).nil?
            record.errors.add(component, "does not work with #{through}")
          end
        end
      end
    end
  end
end
ActiveRecord::Base.extend HasComponents::Validations

class RelationBuilder
  attr_reader :class_name, :table, :first_class, :second_class,
              :first, :second, :source, :foreign_key

  def initialize(from_klass, relation)
    @from_klass = from_klass
    @relation_klass = relation.to_s.classify.constantize

    @class_name = [@from_klass, @relation_klass].map {|k| k.name.pluralize }.sort.join
    @table = class_name.underscore.to_sym
    @first_class = [@from_klass, @relation_klass].map {|k| k.name }.min
    @first = @first_class.underscore.to_sym
    @second_class = [@from_klass, @relation_klass].map {|k| k.name }.max
    @second = @second_class.underscore.to_sym
    if @from_klass.name == @first_class
      @source = :seconds
      @foreign_key = "first_id"
    else
      @source = :firsts
      @foreign_key = "second_id"
    end
  end
end

class ComponentRelation < ActiveRecord::Base
  abstract_class
end
