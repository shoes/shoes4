require 'shoes/spec_helper'

describe Shoes::Keypress do
  include_context "dsl app"

  subject(:keypress) { Shoes::Keypress.new app, &input_block }

  it "should clear" do
    expect(keypress).to respond_to(:remove)
  end
end
