describe Shoes::Configuration do
  describe "#backend" do
    describe ":swt" do
      before { Shoes.configuration.backend = :swt }

      it "sets backend" do
        Shoes.configuration.backend.should == Shoes::Swt
      end
    end
  end
end
