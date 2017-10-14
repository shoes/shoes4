# frozen_string_literal: true

require 'spec_helper'

describe Shoes::Common::Attachable do
  include_context "dsl app"

  subject do
    Class.new do
      include Shoes::Common::Attachable

      attr_reader :style

      def initialize(app, attached_to)
        @app   = app
        @style = { attach: attached_to }
      end
    end
  end

  let(:slot) { double('slot') }

  it "isn't attached" do
    expect(subject.new(app, nil).attached_to).to eq(nil)
  end

  it "attaches" do
    expect(subject.new(app, slot).attached_to).to eq(slot)
  end

  it "attaches to Shoes::Window" do
    expect(subject.new(app, Shoes::Window).attached_to).to eq(app.top_slot)
  end
end
