require 'spec_helper'

describe Shoes::Swt::Line do
  include_context "swt app"

  let(:dsl) { Shoes::Line.new shoes_app, parent, point_a, point_b }
  let(:point_a) { Shoes::Point.new(10, 100) }
  let(:point_b) { Shoes::Point.new(300, 10) }

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
