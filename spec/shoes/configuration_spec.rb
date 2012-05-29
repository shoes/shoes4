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
end
