require 'swt_shoes/spec_helper'

describe Shoes::Swt::Flow do
  include_context "swt app"

  let(:dsl) { double('dsl', app: shoes_app).as_null_object }
  let(:real) { double('real', disposed?: false) }
  let(:parent_real) { double('parent_real', :get_layout => "ok") }

  subject { Shoes::Swt::Flow.new(dsl, parent) }

  it_behaves_like "togglable"

  describe "#initialize" do
    before do
      parent.stub(:real) { parent_real }
      parent_real.stub(:get_layout){double(top_slot: true)}
    end

    it "sets readers" do
      flow = subject
      flow.parent.should == parent
      flow.dsl.should == dsl
      flow.real.should == parent_real
    end
  end
end
