describe Shoes::Configuration do
  context ":swt" do
    describe "#backend" do
      it "sets backend" do
        Shoes.configuration.backend.should == Shoes::Swt
      end
    end

  end
end
