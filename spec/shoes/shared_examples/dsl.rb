# Must pass the container object in the shared examples call.
#
#   it_behaves_like "dsl container", container_object
shared_examples "dsl container" do |container|
  describe "animate" do
    context "defaults" do
      let(:animation) { subject.animate {} }

      specify "is a Shoes::Animation" do
        animation.should be_an_instance_of(Shoes::Animation)
      end

      specify "framerate is 24" do
        animation.framerate.should eq(24)
      end
    end

    context "with numeric argument" do
      let(:animation) { subject.animate(13) {} }

      specify "sets framerate" do
        animation.framerate.should eq(13)
      end
    end

    context "with hash argument" do
      let(:animation) { subject.animate(:framerate => 17) {} }

      specify "sets framerate" do
        animation.framerate.should eq(17)
      end
    end
  end

  describe "flow" do
    it "creates a Shoes::Flow" do
      blk = Proc.new {}
      opts = Hash.new
      flow = subject.flow opts, &blk
      flow.should be_an_instance_of(Shoes::Flow)
    end
  end

  describe "line" do
    it "creates a Shoes::Line" do
      subject.line(10, 15, 20, 30).should be_an_instance_of(Shoes::Line)
    end
  end

  describe "oval" do
    it "creates a Shoes::Oval" do
      subject.oval(10, 50, 250).should be_an_instance_of(Shoes::Oval)
    end
  end

end
