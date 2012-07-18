require 'swt_shoes/spec_helper'

describe Shoes::Swt::Flow do
  let(:dsl) { double('dsl') }
  let(:real) { double('real') }
  let(:parent_real) { double('parent_real') }
  let(:parent_dsl) { double(contents: []) }
  let(:parent) { double('parent', real: parent_real, dsl: parent_dsl) }
  subject { Shoes::Swt::Flow.new(dsl, parent) }

  describe "initialize" do
    before do
      parent_real.stub(:getLayout){mock(top_slot: true)}
    end

    it "should set readers" do
      flow = subject
      flow.parent.should == parent
      flow.dsl.should == dsl
      flow.real.should == parent_real
      flow.contents.should == []
      flow.parent.dsl.contents.first.should == dsl
    end
  end

end
