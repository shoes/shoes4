# frozen_string_literal: true
require 'spec_helper'

describe Shoes::Text do
  include_context "dsl app"

  let(:link) { Shoes::Link.new(app, ['link']) }

  it "finds no links" do
    text = Shoes::Text.new(['text'])
    expect(text.links).to be_empty
  end

  it "finds a link" do
    text = Shoes::Text.new(['text', link])
    expect(text.links).to eq([link])
  end

  it "finds multiple" do
    text = Shoes::Text.new([Shoes::Text.new(['yo', link]), link])
    expect(text.links).to eq([link, link])
  end
end
