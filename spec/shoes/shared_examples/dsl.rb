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

  describe "fill" do
    let(:color) { Shoes::COLORS.fetch :tomato }

    specify "returns a color" do
      subject.fill(color).class.should eq(Shoes::Color)
    end

    # This works differently on a container than on a normal element
    specify "sets on receiver" do
      subject.fill color
      subject.style[:fill].should eq(color)
    end

    specify "applies to subsequently created objects" do
      subject.fill color
      Shoes::Oval.should_receive(:new).with do |*args|
        style = args.pop
        style[:fill].should eq(color)
      end
      subject.oval(10, 10, 100, 100)
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

  describe "rgb" do
    let(:red) { 100 }
    let(:green) { 149 }
    let(:blue) { 237 }
    let(:alpha) { 133 } # cornflower
    let(:app) { ElementMethodsShoeLaces.new }

    it "sends args to Shoes::Color" do
      Shoes::Color.should_receive(:new).with(red, green, blue, alpha)
      app.rgb(red, green, blue, alpha)
    end

    it "defaults to opaque" do
      Shoes::Color.should_receive(:new).with(red, green, blue, Shoes::Color::OPAQUE)
      app.rgb(red, green, blue)
    end
  end

  describe "shape" do
    let(:app) { ElementMethodsShoeLaces.new }
    subject {
      app.shape {
        move_to 400, 300
        line_to 400, 200
        line_to 100, 100
        line_to 400, 300
      }
    }

    it { should be_an_instance_of(Shoes::Shape) }

    it "receives style from app" do
      green = Shoes::COLORS.fetch :green
      app.style[:stroke] = green
      subject.stroke.should eq(green)
    end
  end

  describe "stroke" do
    let(:color) { Shoes::COLORS.fetch :tomato }

    specify "returns a color" do
      subject.stroke(color).class.should eq(Shoes::Color)
    end

    # This works differently on a container than on a normal element
    specify "sets on receiver" do
      subject.stroke color
      subject.style[:stroke].should eq(color)
    end

    specify "applies to subsequently created objects" do
      subject.stroke color
      Shoes::Oval.should_receive(:new).with do |*args|
        style = args.pop
        style[:stroke].should eq(color)
      end
      subject.oval(10, 10, 100, 100)
    end
  end

  describe "strokewidth" do
    specify "returns a number" do
      subject.strokewidth(4).should eq(4)
    end

    specify "sets on receiver" do
      subject.strokewidth 4
      subject.style[:strokewidth].should eq(4)
    end

    specify "applies to subsequently created objects" do
      subject.strokewidth 6
      Shoes::Oval.should_receive(:new).with do |*args|
        style = args.pop
        style[:strokewidth].should eq(6)
      end
      subject.oval(10, 10, 100, 100)
    end
  end

end
