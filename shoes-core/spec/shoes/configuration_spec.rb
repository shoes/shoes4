require 'spec_helper'

describe Shoes::Configuration do
  after { Shoes.configuration.reset }

  describe "#logger" do
    describe ":ruby" do
      before { Shoes.configuration.logger = :ruby }

      it "uses the Ruby logger" do
        expect(Shoes.logger.instance_of?(Shoes::Logger::Ruby)).to eq(true)
      end
    end
  end

  describe "backend" do
    include_context "dsl app"

    let(:dsl_object) { Shoes::Shape.new app, parent }

    describe "#backend_with_app_for" do
      it "passes app.gui to backend" do
        expect(Shoes.configuration.backend::Shape).to receive(:new).with(an_instance_of(Shoes::Shape), app.gui).and_call_original
        dsl_object
      end

      it "returns shape backend object" do
        expect(Shoes.configuration.backend_with_app_for(dsl_object)).to be_instance_of(Shoes.configuration.backend::Shape)
      end

      it "raises ArgumentError for a non-Shoes object" do
        expect { Shoes.configuration.backend_with_app_for(1..100) }.to raise_error(ArgumentError)
      end
    end
  end
end
