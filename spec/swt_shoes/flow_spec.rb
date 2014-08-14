require 'swt_shoes/spec_helper'

describe Shoes::Swt::Flow do
  include_context "swt app"

  let(:dsl) { double('dsl', app: shoes_app,
                     pass_coordinates?: true).as_null_object }
  let(:real) { double('real', disposed?: false) }
  let(:parent_real) { double('parent_real', :get_layout => "ok") }

  subject { Shoes::Swt::Flow.new(dsl, parent) }

  it_behaves_like "togglable"

  it_behaves_like "clickable backend" do
    let(:click_block_parameters) { click_block_coordinates }
  end

  describe "#initialize" do
    before do
      allow(parent).to receive(:real) { parent_real }
      allow(parent_real).to receive(:get_layout){double(top_slot: true)}
    end

    it "sets readers" do
      expect(subject.parent).to eq parent
      expect(subject.dsl).to eq dsl
      expect(subject.real).to eq parent_real
    end
  end
end
