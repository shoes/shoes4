require "shoes/spec_helper"

describe Shoes::EditBox do

  let(:input_block) { Proc.new {} }
  let(:input_opts) { {} }
  let(:app) { Shoes::App.new }
  let(:parent) { Shoes::Flow.new app, app }
  let(:text) {'hello'}
  subject { Shoes::EditBox.new(app, parent, text, input_opts, input_block) }

  it_behaves_like "movable object"
  it_behaves_like "movable object with gui"
  it_behaves_like "an element that can respond to change"

  it { should respond_to :focus }
  it { should respond_to :text  }
  it { should respond_to :text= }
end
