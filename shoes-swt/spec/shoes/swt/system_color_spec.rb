require 'spec_helper'

describe Shoes::Swt::SystemColor do
  subject(:color)  { Shoes::Swt::SystemColor.create('nil', :system_background) }

  its(:class) { is_expected.to eq(Shoes::Swt::SystemColor) }

  describe "underlying SWT object" do
    let(:real) { color.real }

    it "is a native SWT color" do
      expect(real.class).to eq(::Swt::Graphics::Color)
    end
  end
end
