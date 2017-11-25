# frozen_string_literal: true

require 'spec_helper'

describe Shoes::Swt::Common::Visibility do
  let(:clazz) do
    Class.new do
      include Shoes::Swt::Common::Visibility

      attr_reader :real, :dsl

      def initialize(dsl, real = nil)
        @dsl = dsl
        @real = real
      end
    end
  end

  let(:dsl)  { double("dsl") }
  let(:real) { double("real", set_visible: nil) }

  subject { clazz.new(dsl, real) }

  it "hides when DSL is hidden from view" do
    allow(dsl).to receive(:hidden_from_view?).and_return(true)
    expect(real).to receive(:set_visible).with(false)
    subject.update_visibility
  end

  it "shows when DSL is not hidden from view" do
    allow(dsl).to receive(:hidden_from_view?).and_return(false)
    expect(real).to receive(:set_visible).with(true)
    subject.update_visibility
  end

  it "is fine without real supporting visibility" do
    allow(real).to receive(:respond_to?).with(:set_visible)
    expect { subject.update_visibility }.to_not raise_error
  end

  describe "without real" do
    let(:real) { nil }

    it "is harmless" do
      expect { subject.update_visibility }.to_not raise_error
    end
  end
end
