require File.dirname(__FILE__) + '/spec_helper'

describe "has_available_components" do
  class Frame < ActiveRecord::Base; end
  class Case < ActiveRecord::Base
    has_components :frames
  end
  class Lense < ActiveRecord::Base
    has_components :frames
  end
  class Style < ActiveRecord::Base
    belongs_to :frame
    belongs_to :case
    belongs_to :lense

    has_available_components :lenses
    has_available_components :frames, :through => [:case, :lense]
  end

  before(:each) do
    @lense = Lense.create!
    @lense_only = Frame.create!
    @lense.frames << @lense_only
    @lense2 = Lense.create

    @case = Case.create!
    @case_only = Frame.create!
    @case.frames << @case_only

    @shared = Frame.create!
    @lense.frames << @shared
    @case.frames << @shared
    @style = Style.new
  end

  it "should return the simple Model.find(:all) when no :through" do
    @style.available_lenses.should =~ [@lense, @lense2]
  end

  it "should return all items if no component is set" do
    @style.available_frames.should =~ [@lense_only, @case_only, @shared]
  end

  it "should return only the items that work with a component if it's set" do
    @style.lense = @lense
    @style.available_frames.should =~ [@lense_only, @shared]
  end

  it "should return only the items that work with the other component if it's set" do
    @style.case = @case
    @style.available_frames.should =~ [@case_only, @shared]
  end

  it "should return the shared items if both components are set" do
    @style.lense = @lense
    @style.case = @case
    @style.available_frames.should == [@shared]
  end
end
