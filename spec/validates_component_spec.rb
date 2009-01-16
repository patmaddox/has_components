require File.dirname(__FILE__) + '/spec_helper'

describe "validates_component" do
  class Frame < ActiveRecord::Base; end
  class Case < ActiveRecord::Base
    has_components :frames
  end
  class Lense < ActiveRecord::Base
    has_components :frames
  end

  describe "a single :through" do
    before(:each) do
      @frame = Frame.create!
      @lense = Lense.create!

      Style = Class.new(ActiveRecord::Base) do
        belongs_to :frame
        belongs_to :lense
        validates_component :frame, :through => :lense
      end
    end

    it "should be valid when the components work together" do
      @lense.frames << @frame
      Style.new(:lense => @lense, :frame => @frame).should be_valid
    end

    it "should not be valid when the components don't work together" do
      s = Style.new(:lense => @lense, :frame => @frame)
      s.should have(1).error_on(:frame)
    end

    it "should be valid when validated component is not set" do
      Style.new(:lense => @lense).should be_valid
    end

    it "should be valid when through component is not set" do
      Style.new(:frame => @frame).should be_valid
    end
  end

  describe "multiple :through's" do
    before(:each) do
      Style = Class.new(ActiveRecord::Base) do
        belongs_to :frame
        belongs_to :lense
        belongs_to :case
        validates_component :frame, :through => [:lense, :case]
      end

      @lense = Lense.create!
      @lense_only = Frame.create!
      @lense.frames << @lense_only

      @case = Case.create!
      @case_only = Frame.create!
      @case.frames << @case_only

      @shared = Frame.create!
      @lense.frames << @shared
      @case.frames << @shared
      @style = Style.new
    end

    it "should be valid when component works with one, and other is unset" do
      @style.lense = @lense
      @style.frame = @lense_only
      @style.should be_valid
    end

    it "should not be valid when component works with one, both are set" do
      @style.lense = @lense
      @style.frame = @lense_only
      @style.case = @case
      @style.should_not be_valid
      @style.should have(1).error_on(:frame)
    end

    it "should be valid when component works with both, both are set" do
      @style.lense = @lense
      @style.case = @case
      @style.frame = @shared
      @style.should be_valid
    end
  end
end
