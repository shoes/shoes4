require 'shoes/spec_helper'

class Smile < Shoes::Widget
  def initialize(caption)
    banner caption
  end
end

describe Shoes::Widget do
  let(:app) { Shoes::App.new }

  it "creates dsl method on App" do
    app.should respond_to(:smile)
  end

  it "generates instances of its subclass" do
    app.smile("Cheese!").should be_instance_of(Smile)
  end

  it "passes missing methods to app" do
    app.should_receive(:banner).with("Pickles!")
    app.smile("Pickles!")
  end

  it 'sets the current slot as the parent' do
    slot = nil
    widget = nil
    Shoes.app do
      slot = instance_variable_get(:@__app__).current_slot
      widget = smile 'lalala'
    end
    expect(widget.parent).to eq slot
  end
end
