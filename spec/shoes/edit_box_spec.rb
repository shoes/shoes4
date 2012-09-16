require "shoes/spec_helper"

describe Shoes::EditBox do

  let(:input_block) { Proc.new {} }
  let(:input_opts) { {} }
  let(:app) { Shoes::App.new }
  let(:parent) { Shoes::Flow.new app }
  subject { Shoes::EditBox.new(parent, input_opts, input_block) }

  it_behaves_like "movable object"
  it_behaves_like "movable object with gui"

  it { should respond_to :focus }
  it { should respond_to :text  }
  it { should respond_to :text= }
end
