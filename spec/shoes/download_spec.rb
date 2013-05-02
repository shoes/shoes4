require 'shoes/spec_helper'

describe Shoes::Download do
  let(:app) { Shoes::App.new }
  let(:block) { proc{} }
  let(:name) { "http://is.gd/GVAGF7" }
  let(:args) { {:save => "nasa50th.gif"} }
  subject{ Shoes::Download.new app, name, args, &block }

  after do
    sleep 1 until subject.finished?
    File.delete args[:save]
  end

  it "should have started? and finished? methods" do
    subject.should respond_to :started?
    subject.should respond_to :finished?
  end
end
