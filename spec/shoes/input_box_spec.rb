require 'shoes/spec_helper'

describe Shoes::InputBox do
  include_context "dsl app"
  let(:input_opts) {{left: left, top: top, width: width, height: height}}
  let(:left) { 10 }
  let(:top) { 20 }
  let(:width) { 100 }
  let(:height) { 200 }
  let(:text) { "the text" }

  # EditBox is an InputBox but InputBox is enver instantiated itself
  # And there are problems in the backend due to option settings
  subject { Shoes::EditBox.new(app, parent, text, input_opts, input_block) }

  it_behaves_like "object with dimensions"
  it_behaves_like "movable object"
  it_behaves_like "an element that can respond to change"
  it_behaves_like "object with state"

  it { should respond_to :focus }
  it { should respond_to :text  }
  it { should respond_to :text= }

  it 'forwards calls to highlight_text to the backend' do
    expect(subject.gui).to receive(:highlight_text).with(4, 20)
    subject.highlight_text 4, 20
  end

  it 'forwards calls to caret_to to the backend' do
    expect(subject.gui).to receive(:caret_to).with(42)
    subject.caret_to 42
  end

  describe "relative dimensions from parent" do
    subject { Shoes::EditBox.new(app, parent, text, relative_opts) }
    it_behaves_like "object with relative dimensions"
  end

  describe "negative dimensions" do
    subject { Shoes::EditBox.new(app, parent, text, negative_opts) }
    it_behaves_like "object with negative dimensions"
  end
end
