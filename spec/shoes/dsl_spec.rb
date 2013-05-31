require 'shoes/spec_helper'

describe Shoes::DSL do
  describe "append" do
    it "should be able to append" do
      Shoes::App.new.contents.clear
      app = Shoes.app { append { rect 10, 50, 50 } }

      app.contents.size.should eq(1)
    end
  end
end
