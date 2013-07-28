require 'swt_shoes/spec_helper'

# note that many important specs for this may be found in
# shoes_key_listener_spec.rb
describe Shoes::Swt::Keyrelease do
  let(:input_blk) { Proc.new {} }
  let(:opts) { Hash.new }
  let(:app) { double shell: double() }
  let(:dsl) { double('dsl') }
  let(:block) { proc{ |key| key} }
  subject { Shoes::Swt::Keyrelease.new dsl, app, &block}

  describe "#initialize" do
    it "adds key listener" do
      app.shell.should_receive(:add_key_listener)
      subject
    end
  end
end