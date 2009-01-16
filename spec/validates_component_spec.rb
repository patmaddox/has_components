require File.dirname(__FILE__) + '/spec_helper'

describe "validates_component" do
  class Frame < ActiveRecord::Base; end
  class Lense < ActiveRecord::Base
    has_components :frames
  end
  class Style < ActiveRecord::Base
    belongs_to :frame
    belongs_to :lense
    validates_component :frame, :through => :lense
  end

  before(:each) do
    @frame = Frame.create!
    @lense = Lense.create!
  end

  it "should be valid when the components work together" do
    @lense.frames << @frame
    Style.new(:lense => @lense, :frame => @frame).should be_valid
  end

  it "should be not valid when the components don't work together" do
    s = Style.new(:lense => @lense, :frame => @frame)
    s.should_not be_valid
    s.should have(1).error_on(:frame)
  end

  it "should be valid when validated component is not set" do
    Style.new(:lense => @lense).should be_valid
  end

  it "should be valid when through component is not set" do
    Style.new(:frame => @frame).should be_valid
  end
end
