require 'shoes/spec_helper'

class Smile < Shoes::Widget
  def initialize(caption)
    banner caption
  end
end

class Face < Shoes::Widget
  def initialize
    para  "Hair"
    smile "Toothsome"
  end
end

describe Shoes::Widget do
  let(:app) { Shoes::App.new }

  it "creates dsl method on App" do
    expect(app).to respond_to(:smile)
  end

  it "generates instances of its subclass" do
    expect(app.smile("Cheese!")).to be_instance_of(Smile)
  end

  it "passes missing methods to app" do
    expect(app).to receive(:banner).with("Pickles!")
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

  it "allows can use other widgets from widget initialize" do
    expect(app).to receive(:smile)
    app.face
  end

  describe 'together with the URL sub system' do
    let!(:klazz) do
      Class.new(Shoes) do
        include RSpec::Matchers

        url '/', :check_smile
        url '/smile', :smile

        def check_smile
          expect(self).to respond_to :smile
        end
      end
    end

    it 'responds to widget defined methods like smile' do
      Shoes.app
    end

    it 'really smiles' do
      expect_any_instance_of(Smile).to receive(:initialize)
      Shoes.app do visit '/smile' end
    end
  end
end
