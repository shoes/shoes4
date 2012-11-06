require 'shoes/spec_helper'

describe Shoes::Image do
  describe "basic" do
    let(:app) { Shoes::App.new }
    let(:parent) { double("parent").as_null_object }
    let(:filename) { File.expand_path "../../../static/shoes-icon.png", __FILE__ }
    subject { Shoes::Image.new(parent, filename) }
    it { should be_instance_of(Shoes::Image) }
    it_behaves_like "movable object"
    it_behaves_like "clearable object"
  end
end
