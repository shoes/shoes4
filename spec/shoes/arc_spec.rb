describe Shoes::Arc do
  context "basic" do
    let(:gui) { double("gui") }
    let(:app) { double("app", :gui => gui) }
    let(:opts) { {:app => app } }

    subject { Shoes::Arc.new(13, 44, 200, 300, 0, Shoes::TWO_PI, opts) }

    it_behaves_like "object with stroke"
    it_behaves_like "object with fill"

    it "is a Shoes::Arc" do
      subject.class.should be(Shoes::Arc)
    end

    its(:left) { should eq(13) }
    its(:top) { should eq(44) }
    its(:width) { should eq(200) }
    its(:height) { should eq(300) }
    its(:angle1) { should eq(0) }
    its(:angle2) { should eq(Shoes::TWO_PI) }
  end
end
