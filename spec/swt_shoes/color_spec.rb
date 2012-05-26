require 'swt_shoes/spec_helper'

describe SwtShoes::Color do
  subject { Shoes::COLORS[:salmon].to_native }

  its(:class) { should eq(Java::OrgEclipseSwtGraphics::Color) }
  its(:red) { should eq(250) }
  its(:green) { should eq(128) }
  its(:blue) { should eq(114) }
end
