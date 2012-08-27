describe Shoes::Configuration do
  context ":swt" do
    before :each do
      Shoes.configuration.backend = :swt
    end

    describe "#backend" do
      it "sets backend" do
        Shoes.configuration.backend.should == Shoes::Swt
      end
    end

  end
end
