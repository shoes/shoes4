require 'shoes/spec_helper'

describe Shoes::Keyrelease do
  include_context "dsl app"

  subject(:keyrelease) { Shoes::Keyrelease.new app, &input_block }

  it "should clear" do
    expect(keyrelease).to respond_to(:remove)
  end

end
