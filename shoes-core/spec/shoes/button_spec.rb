# frozen_string_literal: true

require 'spec_helper'

describe Shoes::Button do
  include_context "dsl app"

  let(:input_opts) do
    { left: left, top: top, width: width, height: height, margin: margin, state: "disabled" }
  end

  let(:left)   { 13 }
  let(:top)    { 44 }
  let(:width)  { 131 }
  let(:height) { 137 }
  let(:margin) { 14 }

  subject(:button) { Shoes::Button.new(app, parent, "text", input_opts, input_block) }

  it_behaves_like "movable object"
  it_behaves_like "object with state"
  it_behaves_like "object with style" do
    let(:subject_without_style) { Shoes::Button.new(app, parent, "text") }
    let(:subject_with_style) { Shoes::Button.new(app, parent, "text", arg_styles) }
  end
  it_behaves_like "object with dimensions"

  it { is_expected.to respond_to :click }
  it { is_expected.to respond_to :focus }
  it { is_expected.to respond_to :text= }

  describe "initialize" do
    its(:parent) { should eq(parent) }
    its(:text) { should eq("text") }
    its(:width) { should eq(131) }
    its(:height) { should eq(137) }
    its(:state) { should eq("disabled") }
  end

  describe ".text=" do
    it "changes the text" do
      expect(subject.gui).to receive(:text=).with("something else")
      subject.text = "something else"
      expect(subject.text).to eq "something else"
    end
  end

  describe "relative dimensions" do
    subject { Shoes::Button.new(app, parent, "text", relative_opts, input_block) }
    it_behaves_like "object with relative dimensions"
  end

  describe "negative dimensions" do
    subject { Shoes::Button.new(app, parent, "text", negative_opts, input_block) }
    it_behaves_like "object with negative dimensions"
  end

  describe "no release" do
    it "doesn't allow releasing despite allowing clicks" do
      expect(subject).not_to respond_to(:release)
    end
  end
end
