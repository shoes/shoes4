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
end
