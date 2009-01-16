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
    @style.lenses.should =~ [@lense, @lense2]
  end
end
