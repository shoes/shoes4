require 'spec_helper'

describe Shoes::Swt::Line do
  include_context "swt app"

  let(:dsl) { Shoes::Line.new shoes_app, parent, 10, 100, 300, 10 }

  subject { Shoes::Swt::Line.new(dsl, swt_app) }

  context "#initialize" do
    it { is_expected.to be_instance_of(Shoes::Swt::Line) }
    its(:dsl) { is_expected.to be(dsl) }
  end

  it_behaves_like "paintable"
  it_behaves_like "updating visibility"
  it_behaves_like "clickable backend"

  it { is_expected.to respond_to :remove }
end
