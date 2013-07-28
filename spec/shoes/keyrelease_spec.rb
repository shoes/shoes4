require 'shoes/spec_helper'

describe Shoes::Keyrelease do
  let(:input_blk) { Proc.new {} }
  let(:app) { Shoes::App.new({}, &input_blk) }
  let(:block) { proc{} }
  subject{ Shoes::Keyrelease.new app, &block }

  it "should clear" do
    subject.should respond_to :clear
  end

end
