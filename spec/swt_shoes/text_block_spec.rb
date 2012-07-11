require 'swt_shoes/spec_helper'

describe Shoes::Swt::TextBlock do
  let(:dsl) { double('dsl', :font_size= => 10,
                      font_size: 10, :font_size_no_update => nil,
                      :font_size_no_update= => nil,
                      :text => "") }
  let(:parent) { double('parent') }
  let(:block) { double('block') }
  let(:real) { double('real').as_null_object }

  subject { Shoes::Swt::TextBlock.new dsl, parent, block }

  before :each do
    parent.stub(:real)
    ::Swt::Graphics::Font.stub(:new) { real }
    st = ::Swt::Custom::StyledText
    st.stub(:new) { real }
  end

  it { should respond_to :hidden }
  it { should respond_to :set_font }

  describe "#initialize" do
    it "disables the caret" do
      real.should_receive(:caret=).with(nil)
      subject
    end

    it "makes sure the element isn't editable" do
      real.should_receive(:editable=).with(false)
      subject
    end
  end
end
