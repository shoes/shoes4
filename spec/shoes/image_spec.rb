require 'shoes/spec_helper'

describe Shoes::Image do
  describe "basic" do
    let(:parent) { double("parent").as_null_object }
    subject { Shoes::Image.new(parent, "../static/shoes-icon.png") }
    it { should be_instance_of(Shoes::Image) }
    it_behaves_like "movable object"
  end
end
