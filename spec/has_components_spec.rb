require File.dirname(__FILE__) + '/spec_helper'

describe "HasComponents" do
  # Define them blank and then reopen them
  # so we don't have to rely on const_missing
  class Frame < ActiveRecord::Base; end
  class Lense < ActiveRecord::Base; end

  class Frame < ActiveRecord::Base
    has_components :lenses
  end

  it "should know what kind of components it has" do
    Frame.component_types.should include(:lenses)
  end

  it "should know component types for instances" do
    Frame.new.component_types.should include(:lenses)
  end

  it "should ask instances for components of a certain type" do
    Frame.new.lenses.should == []
  end

  it "should allow adding component relations the long way" do
    no = Lense.create
    yes = Lense.create!
    f = Frame.create!
    FramesLenses.create! :frame => f, :lense => yes
    f.reload
    f.lenses.should include(yes)
    f.lenses.should_not include(no)
  end
end
