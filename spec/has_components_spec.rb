require File.dirname(__FILE__) + '/spec_helper'

describe "HasComponents" do
  class Frame < ActiveRecord::Base
    has_components :lenses
  end

  it "should know what kind of components it has" do
    Frame.component_types.should include(:lenses)
  end

  it "should know component types for instances" do
    Frame.new.component_types.should include(:lenses)
  end
end
