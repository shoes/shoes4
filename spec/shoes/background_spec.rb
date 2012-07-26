require 'shoes/spec_helper'

describe Shoes::Background do
  let(:app_width) { 400 }
  let(:app_height) { 200 }
  let(:white) { Shoes::COLORS[:white] }
  let(:blue)  { Shoes::COLORS[:blue] }
  let(:paint_event) do
    paint_event = double "paint_event"
    paint_event.stub(height: app_height, width: app_width)
    paint_event
  end
  let(:input_block) { Proc.new {} }
  let(:input_opts) { { height: 30 } }
  let(:parent) { double("parent").as_null_object }
  subject { Shoes::Background.new(parent, blue,
                                  input_opts, input_block) }

  it { should respond_to :fill }

  it "should set the color" do
    subject.color.should eql blue
  end
end
