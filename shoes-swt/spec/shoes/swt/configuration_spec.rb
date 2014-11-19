require 'shoes/swt/spec_helper'

describe Shoes::Configuration do
  context ":swt" do
    describe "#backend" do
      it "sets backend" do
        expect(Shoes.configuration.backend).to eq(Shoes::Swt)
      end
    end

  end
end
