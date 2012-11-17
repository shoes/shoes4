require 'swt_shoes/spec_helper'

describe Shoes::Swt::Color do
  subject { Shoes::Swt::Color.new(Shoes::COLORS[:salmon]) }

  its(:class) { should eq(Shoes::Swt::Color) }
  its(:red) { should eq(250) }
  its(:green) { should eq(128) }
  its(:blue) { should eq(114) }
end
