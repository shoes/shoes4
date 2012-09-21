require 'swt_shoes/spec_helper'

describe Shoes::Swt::Flow do
  let(:dsl) { double('dsl') }
  let(:real) { double('real') }
  let(:parent_real) { double('parent_real', :get_layout => "ok") }
  let(:parent_dsl) { double(contents: []) }
  let(:parent) { double('parent', real: parent_real, dsl: parent_dsl, app: "app", :top_slot => "top slot") }
  subject { Shoes::Swt::Flow.new(dsl, parent) }

  describe "#initialize" do
    before do
      parent_real.stub(:get_layout){mock(top_slot: true)}
    end

    it "sets readers" do
      flow = subject
      flow.parent.should == parent
      flow.dsl.should == dsl
      flow.real.should == parent_real
      flow.contents.should == []
      flow.parent.dsl.contents.first.should == dsl
    end
  end
end
