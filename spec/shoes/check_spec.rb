require 'shoes/spec_helper'

describe Shoes::Check do
  subject { Shoes::Check.new(app, parent, input_block) }
  let(:input_block) { Proc.new {} }
  let(:app) { Shoes::App.new }
  let(:parent) { Shoes::Flow.new app, app: app }

  it_behaves_like "checkable"
end
