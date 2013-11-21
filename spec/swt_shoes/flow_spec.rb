require 'swt_shoes/spec_helper'

describe Shoes::Swt::Flow do
  let(:container) { real }
  let(:gui)    { double("gui", real: real) }
  let(:app)    { double("app", gui: gui) }
  let(:dsl) { double('dsl', app: app).as_null_object }
  let(:real) { double('real', is_disposed?: false) }
  let(:parent_real) { double('parent_real', :get_layout => "ok") }
  let(:parent_dsl) { double(contents: []) }
  let(:parent) { double('parent', real: parent_real, dsl: parent_dsl, app: "app", :top_slot => "top slot") }

  subject { Shoes::Swt::Flow.new(dsl, parent) }

  it_behaves_like "togglable"

  describe "#initialize" do
    before do
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
