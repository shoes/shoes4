# frozen_string_literal: true

require 'spec_helper'

describe Shoes::Keyrelease do
  include_context "dsl app"

  subject(:keyrelease) { Shoes::Keyrelease.new app, &input_block }

  it "should clear" do
    expect(keyrelease).to respond_to(:remove)
  end

  describe "dsl" do
    it "returns app, not the handler" do
      returned = dsl.keyrelease do
      end

      expect(returned).to eq(user_facing_app)
    end
  end
end
