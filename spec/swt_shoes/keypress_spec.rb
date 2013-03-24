require 'swt_shoes/spec_helper'

describe Shoes::Swt::Keypress, :swt do
  let(:input_blk) { Proc.new {} }
  let(:opts) { Hash.new }
  let(:app) { Shoes::App.new(opts, &input_blk) }
  let(:dsl) { double('dsl') }
  let(:block) { proc{} }
  subject { Shoes::Swt::Keypress.new dsl, app, &block}

  context "#initialize" do
    specify "adds key listener" do
      app.shell.should_receive(:addKeyListener)
      subject
    end
  end

  specify 'Swt::SWT::CR is "\n"' do
    Shoes::Swt::Keypress::KEY_NAMES[::Swt::SWT::CR].should eq("\n")
  end
end
