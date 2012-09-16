require 'spec_helper'

describe Shoes::Configuration do
  after { Shoes.configuration.reset }

  describe "#logger" do
    describe ":ruby" do
      before { Shoes.configuration.logger = :ruby }

      it "uses the Ruby logger" do
        Shoes.logger.instance_of?(Shoes::Logger::Ruby).should == true
      end
    end

    describe ":log4j" do
      before { Shoes.configuration.logger = :log4j }

      it "uses Log4j" do
        Shoes.logger.instance_of?(Shoes::Logger::Log4j).should == true
      end
    end
  end

  describe "backend" do
    let(:app) { Shoes::App.new }
    let(:args) { Hash.new }
    let(:dsl_object) { Shoes::Shape.new app, args }

    it "raises ArgumentError on bad input" do
      lambda { Shoes.configuration.backend = :bogus }.should raise_error(LoadError)
    end

    describe "#backend_with_app_for" do
      it "passes app.gui to backend" do
        Shoes.configuration.backend::Shape.should_receive(:new).with(dsl_object, app.gui, args)
        dsl_object
      end

      specify "returns shape backend object" do
        Shoes.configuration.backend_with_app_for(dsl_object, args).should be_instance_of(Shoes.configuration.backend::Shape)
      end
    end
  end
end
