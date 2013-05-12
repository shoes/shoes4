require 'shoes/spec_helper'

describe Shoes::Radio do
  subject { Shoes::Radio.new(app, parent, input_opts, input_block) }
  let(:input_block) { Proc.new {} }
  let(:input_opts) { Hash.new }
  let(:app) { Shoes::App.new }
  let(:parent) { Shoes::Flow.new app, app: app }

  it_behaves_like "checkable"

  # should be unchecked when it's created"
  # only one radio in a group can be checked
end
