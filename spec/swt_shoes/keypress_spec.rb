require 'swt_shoes/spec_helper'

# note that many important specs for this may be found in
# shoes_key_listener_spec.rb
describe Shoes::Swt::Keypress do
  let(:input_blk) { Proc.new {} }
  let(:opts) { Hash.new }
  let(:app) { Shoes::App.new(opts, &input_blk) }
  let(:dsl) { double('dsl') }
  let(:block) { proc{ |key| key} }
  subject { Shoes::Swt::Keypress.new dsl, app, &block}

  describe "#initialize" do
    it "adds key listener" do
      app.shell.should_receive(:add_key_listener)
      subject
    end
  end
end
