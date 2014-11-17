require "shoes/spec_helper"

module Learning
  class App
    attr_accessor :gui

    def initialize
      @gui = gui_init
    end
  end
end

module TextPlugin
  module App
    def gui_init
      "Peter"
    end
  end
end

  class Learning::App
    include TextPlugin::App
  end

describe "A Shoes Framework" do

  it "should include Framework Plugins" do
    expect(Learning::App.new.gui).to eq("Peter")
  end
end
