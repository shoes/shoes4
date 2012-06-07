require 'spec_helper'

describe Shoes::Configuration do
  after { Shoes.configuration.reset }

  describe "#logger" do
    describe ":ruby" do
      before { Shoes.configuration.logger = :ruby }

      it "uses the Ruby logger" do
        Shoes.logger.should be_an_instance_of(Shoes::Logger::Ruby)
      end
    end

    describe ":log4j" do
      before { Shoes.configuration.logger = :log4j }

      it "uses Log4j" do
        Shoes.logger.should be_an_instance_of(Shoes::Logger::Log4j)
      end
    end
  end

  describe "backend" do
    it "raises ArgumentError on bad input" do
      lambda { Shoes.configuration.backend = :bogus }.should raise_error(ArgumentError)
    end

    describe ":mock" do
      before { Shoes.configuration.backend = :mock }

      it "sets backend to Shoes::Mock" do
        Shoes.configuration.backend.should eq(Shoes::Mock)
      end
    end
  end

  describe "#backend_for" do
    let(:dsl_object) { double("dsl object", :class => Shoes::Shape) }
    let(:args) { double("args") }

    it "returns shape backend object" do
      Shoes.configuration.backend_for(dsl_object, args).should be_instance_of(Shoes::Mock::Shape)
    end
  end
end
