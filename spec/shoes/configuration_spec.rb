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
  end

  describe "backend" do
    include_context "dsl app"

    let(:args) { Hash.new }
    let(:dsl_object) { Shoes::Shape.new app, args }

    describe "#backend_with_app_for" do
      it "passes app.gui to backend" do
        Shoes.configuration.backend::Shape.should_receive(:new).with(dsl_object, app.gui, args)
        dsl_object
      end

      it "returns shape backend object" do
        Shoes.configuration.backend_with_app_for(dsl_object, args).should be_instance_of(Shoes.configuration.backend::Shape)
      end

      it "raises ArgumentError for a non-Shoes object" do
        lambda { Shoes.configuration.backend_with_app_for(1..100) }.should raise_error(ArgumentError)
      end
    end
  end
end
