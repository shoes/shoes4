require 'swt_shoes/spec_helper'

# note that many important specs for this may be found in
# shoes_key_listener_spec.rb
describe Shoes::Swt::KeyEvent do
  let(:input_blk) { Proc.new {} }
  let(:opts) { Hash.new }
  let(:app) { double shell: double() }
  let(:dsl) { double('dsl') }
  let(:block) { proc{ |key| key} }

  describe "Subclass Keypress" do
    it "adds key listener on creation" do
      app.shell.should_receive(:add_key_listener)
      Shoes::Swt::Keypress.new dsl, app, &block
    end
  end

  describe "Subclass Keypress" do
    it "adds key listener on creation" do
      app.shell.should_receive(:add_key_listener)
      Shoes::Swt::Keyrelease.new dsl, app, &block
    end
  end
end
