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
    let(:dsl_object) { double("dsl object", :class => Shoes::Shape) }
    let(:args) { double("args") }

    it "raises ArgumentError on bad input" do
      lambda { Shoes.configuration.backend = :bogus }.should raise_error(LoadError)
    end

    describe ":mock" do
      before { Shoes.configuration.backend = :mock }

      it "sets backend to Shoes::Mock" do
        Shoes.configuration.backend.should eq(Shoes::Mock)
      end
    end
    specify "#backend_for returns shape backend object" do
      Shoes.configuration.backend_for(dsl_object, args).should be_instance_of(Shoes::Mock::Shape)
    end

    describe "#backend_with_app_for" do
      let(:app) { double('app', :gui => app_gui) }
      let(:app_gui) { double('app_gui') }

      before :each do
        dsl_object.stub(:app) { app }
      end

      it "passes app.gui to backend" do
        Shoes::Mock::Shape.should_receive(:new).with(dsl_object, app_gui, args)
        Shoes.configuration.backend_with_app_for(dsl_object, args)
      end
    end
  end
end
