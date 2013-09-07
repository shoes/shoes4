require 'swt_shoes/spec_helper'

describe Shoes::Swt::Button do
  let(:text) { "TEXT" }
  let(:dsl) { double('dsl', text: text, blk: block) }
  let(:parent) { double('parent') }
  let(:block) { proc {} }
  let(:real) { double('real', disposed?: false).as_null_object }

  subject { Shoes::Swt::Button.new dsl, parent }

  before :each do
    parent.stub(:real)
    parent.stub(:dsl){double(contents: [])}
    dsl.stub(:width=)
    dsl.stub(:height=)
    ::Swt::Widgets::Button.stub(:new) { real }
  end

  it_behaves_like "buttons"
  it_behaves_like "movable element", 140, 300
  it_behaves_like "clearable native element"

  describe "#initialize" do
    it "sets text on real element" do
      real.should_receive(:set_text).with(text)
      subject
    end
  end

  describe 'eval block' do
    it 'calls the block' do
      block.should_receive(:call).with(dsl)
      subject.eval_block
    end
  end
end
