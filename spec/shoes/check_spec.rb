require 'shoes/spec_helper'

describe Shoes::Check do
  subject { Shoes::Check.new(parent, input_opts, input_block) }
  let(:input_block) { Proc.new {} }
  let(:input_opts) { {} }
  let(:app) { Shoes::App.new }
  let(:parent) { Shoes::Flow.new app }

  it_behaves_like "checkable"
end
