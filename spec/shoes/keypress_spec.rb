require 'shoes/spec_helper'

describe Shoes::Keypress do
  let(:input_blk) { Proc.new {} }
  let(:app) { Shoes::App.new({}, &input_blk) }
  let(:opts) { {app: app} }
  let(:block) { proc{} }
  subject{ Shoes::Keypress.new opts, &block }

  it "should clear" do
    subject.should respond_to :clear
  end
end
