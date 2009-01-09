require File.dirname(__FILE__) + '/spec_helper'

describe "HasComponents" do
  # Define them blank and then reopen them
  # so we don't have to rely on const_missing
  class Frame < ActiveRecord::Base; end
  class Lense < ActiveRecord::Base; end

  class Frame < ActiveRecord::Base
    has_components :lenses
  end
  class Lense < ActiveRecord::Base
    has_components :frames
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

  describe "relations set up" do
    before(:each) do
      @no = Lense.create
      @yes = Lense.create!
      @f = Frame.create!
      FramesLenses.create! :frame => @f, :lense => @yes
      [@no, @yes, @f].each(&:reload)
    end

    it "should find items in the association" do
      @f.lenses.should include(@yes)
    end

    it "should not find items not in the association" do
      @f.lenses.should_not include(@no)
    end

    it "should work from the other side of the association" do
      @yes.frames.should include(@f)
      @no.frames.should_not include(@f)
    end
  end

  it "should allow adding component relations via assoc<<" do
    no = Lense.create
    yes = Lense.create!
    f = Frame.create!
    f.lenses << yes
    f.reload
    f.lenses.should include(yes)
    f.lenses.should_not include(no)
  end
end
