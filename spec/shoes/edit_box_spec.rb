require "shoes/spec_helper"

describe Shoes::EditBox do

  let(:input_block) { Proc.new {} }
  let(:input_opts)  { {} }
  let(:app)         { Shoes::App.new }
  let(:parent)      { Shoes::Flow.new app, app: app }
  let(:text)        { nil }
  subject { Shoes::EditBox.new(parent, text, input_opts, input_block) }

  it_behaves_like "movable object"
  it_behaves_like "movable object with gui"
  it_behaves_like "an element that can respond to change"

  it { should respond_to :focus }
  it { should respond_to :text  }
  it { should respond_to :text= }

  context "with text given in its constructor" do
    let(:text) { "text here, no kidding" }
    it "should set that as its text property" do
      subject.text.should == text
    end
  end
end
