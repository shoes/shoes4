# frozen_string_literal: true

require 'spec_helper'

describe Shoes::Keypress do
  include_context "dsl app"

  subject(:keypress) { Shoes::Keypress.new app, &input_block }

  it "should clear" do
    expect(keypress).to respond_to(:remove)
  end

  describe "dsl" do
    it "returns app, not the handler" do
      returned = dsl.keypress do
      end

      expect(returned).to eq(user_facing_app)
    end
  end
end
