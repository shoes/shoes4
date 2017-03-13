# frozen_string_literal: true
require 'spec_helper'

describe Shoes::Configuration do
  include_context "dsl app"

  describe "fail fast" do
    before do
      ENV["SHOES_FAIL_FAST"] = nil
      @prior_fail_fast = Shoes.configuration.fail_fast
    end

    after do
      ENV["SHOES_FAIL_FAST"] = nil
      Shoes.configuration.fail_fast = @prior_fail_fast
    end

    it "defaults to false" do
      expect(Shoes.configuration.fail_fast).to be_falsey
    end

    it "can be set by ENV" do
      ENV["SHOES_FAIL_FAST"] = "yup"
      expect(Shoes.configuration.fail_fast).to be_truthy
    end

    it "can be set directly" do
      Shoes.configuration.fail_fast = true
      expect(Shoes.configuration.fail_fast).to be_truthy
    end
  end

  describe "backend" do
    let(:dsl_object) { Shoes::Shape.new app, parent, 0, 0 }

    describe "#backend_for" do
      it "passes app.gui to backend" do
        expect(Shoes.configuration.backend::Shape).to receive(:new).with(an_instance_of(Shoes::Shape), app.gui).and_call_original
        dsl_object
      end

      it "returns shape backend object" do
        expect(Shoes.backend_for(dsl_object)).to be_instance_of(Shoes.configuration.backend::Shape)
      end

      it "raises ArgumentError for a non-Shoes object" do
        expect { Shoes.backend_for(1..100) }.to raise_error(ArgumentError)
      end
    end

    describe '#backend_class' do
      it 'returns the backend class for a dsl object' do
        expect(Shoes.configuration.backend_class(dsl_object)).to eq(Shoes.configuration.backend::Shape)
      end

      it 'returns the backend class if fed with a class' do
        expect(Shoes.configuration.backend_class(Shoes::Shape)).to eq(Shoes.configuration
                                                .backend::Shape)
      end

      it 'raises an error when fed with a non existant class' do
        expect { Shoes.configuration.backend_class(Array) }.to raise_error(ArgumentError)
      end
    end
  end
end
