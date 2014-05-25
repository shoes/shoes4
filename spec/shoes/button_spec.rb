require "shoes/spec_helper"

describe Shoes::Button do
  include_context "dsl app"
  let(:input_opts) { {:left => left, :top => top, :width => width,
                      :height => height, :margin => margin, :state => "disabled"} }

  let(:left)   { 13 }
  let(:top)    { 44 }
  let(:width)  { 131 }
  let(:height) { 137 }
  let(:margin) { 14 }

  subject(:button) { Shoes::Button.new(app, parent, "text", input_opts, input_block) }

  it_behaves_like "movable object"
  it_behaves_like "object with state"
  it_behaves_like "object with dimensions"

  it { should respond_to :click }
  it { should respond_to :focus }

  describe "initialize" do
    its(:parent) { should eq(parent) }
    its(:blk) { should eq(input_block) }
    its(:text) { should eq("text") }
    its(:width) { should eq(131) }
    its(:height) { should eq(137) }
    its(:state) { should eq("disabled") }
  end

  describe "relative dimensions" do
    subject { Shoes::Button.new(app, parent, "text", relative_opts, input_block) }
    it_behaves_like "object with relative dimensions"
  end

  describe "negative dimensions" do
    subject { Shoes::Button.new(app, parent, "text", negative_opts, input_block) }
    it_behaves_like "object with negative dimensions"
  end
end
