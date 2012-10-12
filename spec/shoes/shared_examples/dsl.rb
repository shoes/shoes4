shared_context "style context" do
  let(:fill_color) { Shoes::COLORS.fetch(:tomato) }
  let(:stroke_color) { Shoes::COLORS.fetch(:chartreuse) }

  before :each do
    subject.fill fill_color
    subject.stroke stroke_color
  end
end

# Specs behavior for "global" fill
#
# @example
#   Shoes.app do
#     fill tomato
#     arc 400, 200, 200, 300, 0, Shoes::HALF_PI
#   end
#
# In these specs, subject is Shoes::App, element is created element (e.g. Shoes::Arc)
shared_examples_for "persistent fill" do
  include_context "style context"

  specify "passes to element" do
    element.fill.should eq(fill_color)
  end
end

shared_examples_for "persistent stroke" do
  include_context "style context"

  specify "passes to element" do
    element.stroke.should eq(stroke_color)
  end
end

shared_examples_for "circle" do
  specify "makes a Shoes::Oval" do
    circle.should be_instance_of(Shoes::Oval)
  end

  specify "sets proper dimensions" do
    circle.top.should eq(30)
    circle.left.should eq(20)
    circle.width.should eq(100)
    circle.height.should eq(100)
  end
end

shared_examples_for "square" do
  specify "makes a Shoes::Rect" do
    rect.should be_an_instance_of(Shoes::Rect)
  end

  specify "sets proper dimensions" do
    rect.left.should eq(40)
    rect.top.should eq(30)
    rect.width.should eq(200)
    rect.height.should eq(200)
  end
end

shared_examples_for "rect" do
  specify "makes a Shoes::Rect" do
    rect.should be_an_instance_of(Shoes::Rect)
  end

  specify "sets proper dimensions" do
    rect.left.should eq(40)
    rect.top.should eq(30)
    rect.width.should eq(200)
    rect.height.should eq(100)
  end
end

# Shared examples for app, flow, stack
shared_examples "dsl container" do
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

  describe "arc" do
    let(:arc) { subject.arc(13, 44, 200, 300, 0, Shoes::TWO_PI) }

    specify "creates a Shoes::Arc" do
      arc.should be_an_instance_of(Shoes::Arc)
    end

    it_behaves_like "persistent fill" do
      let(:element) { arc }
    end

    it_behaves_like "persistent stroke" do
      let(:element) { arc }
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

  describe "nofill" do
    specify "sets nil" do
      subject.nofill
      subject.style[:fill].should eq(nil)
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

    context "eccentric, from explicit arguments" do
      let(:oval) { subject.oval(20, 30, 100, 200) }

      specify "makes a Shoes::Oval" do
        oval.should be_instance_of(Shoes::Oval)
      end

      specify "sets proper dimensions" do
        oval.top.should eq(30)
        oval.left.should eq(20)
        oval.width.should eq(100)
        oval.height.should eq(200)
      end
    end

    context "circle, from explicit arguments:" do
      context "width and height" do
        it_behaves_like "circle" do
          let(:circle) { subject.oval(20, 30, 100, 100) }
        end
      end

      context "diameter" do
        it_behaves_like "circle" do
          let(:circle) { subject.oval(20, 30, 100) }
        end
      end
    end

    context "circle, from style hash" do
      context "left, top, height, width" do
        it_behaves_like "circle" do
          let(:circle) { subject.oval(left: 20, top: 30, width: 100, height: 100) }
        end
      end

      context "left, top, height, width, center: false" do
        it_behaves_like "circle" do
          let(:circle) { subject.oval(left: 20, top: 30, width: 100, height: 100, center: false) }
        end
      end

      context "left, top, diameter" do
        it_behaves_like "circle" do
          let(:circle) { subject.oval(left: 20, top: 30, diameter: 100) }
        end
      end

      context "left, top, width, height, center: true" do
        it_behaves_like "circle" do
          let(:circle) { subject.oval(left: 70, top: 80, width: 100, height: 100, center: true) }
        end
      end
    end
  end

  describe "rect" do
    context "unequal sides, from explicit arguments" do
      let(:rect) { subject.rect 40, 30, 200, 100 }

      it_behaves_like "rect"

      specify "defaults to corner radius of 0" do
        rect.corners.should eq(0)
      end
    end

    context "unequal sides, round corners, from explicit arguments" do
      let(:rect) { subject.rect 40, 30, 200, 100, 12 }

      it_behaves_like "rect"

      specify "sets corner radius" do
        rect.corners.should eq(12)
      end
    end

    context "unequal sides, from style hash" do
      let(:rect) { subject.rect :left => 40, :top => 30, :width => 200, :height => 100 }

      it_behaves_like "rect"

      specify "defaults to corner radius of 0" do
        rect.corners.should eq(0)
      end
    end

    context "unequal sides, rounded corners, from style hash" do
      let(:rect) { subject.rect :left => 40, :top => 30, :width => 200, :height => 100, :curve => 12 }

      it_behaves_like "rect"

      specify "sets corner radius" do
        rect.corners.should eq(12)
      end
    end

    context "square, from explicit arguments" do
      let(:rect) { subject.rect 40, 30, 200 }

      it_behaves_like "square"

      specify "defaults to corner radius of 0" do
        rect.corners.should eq(0)
      end
    end

    context "square, from style hash" do
      let(:rect) { subject.rect :left => 40, :top => 30, :width => 200 }

      it_behaves_like "square"

      specify "defaults to corner radius of 0" do
        rect.corners.should eq(0)
      end
    end
  end

  describe "rgb" do
    let(:red) { 100 }
    let(:green) { 149 }
    let(:blue) { 237 }
    let(:alpha) { 133 } # cornflowerblue

    it "sends args to Shoes::Color" do
      Shoes::Color.should_receive(:new).with(red, green, blue, alpha)
      subject.rgb(red, green, blue, alpha)
    end

    it "defaults to opaque" do
      Shoes::Color.should_receive(:new).with(red, green, blue, Shoes::Color::OPAQUE)
      subject.rgb(red, green, blue)
    end

    describe "named color method" do
      specify "produces correct color" do
        subject.cornflowerblue.should eq(Shoes::Color.new red, green, blue)
      end

      specify "accepts alpha arg" do
        subject.cornflowerblue(alpha).should eq(Shoes::Color.new red, green, blue, alpha)
      end
    end
  end

  describe "shape" do
    let(:shape) {
      subject.shape {
        move_to 400, 300
        line_to 400, 200
        line_to 100, 100
        line_to 400, 300
      }
    }

    specify "creates a Shoes::Shape" do
      shape.should be_an_instance_of(Shoes::Shape)
    end

    it "receives style from app" do
      green = Shoes::COLORS.fetch :green
      subject.style[:stroke] = green
      shape.stroke.should eq(green)
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

  describe "nostroke" do
    specify "sets nil" do
      subject.nostroke
      subject.style[:stroke].should eq(nil)
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

  describe "text_block" do
    it "should set banner font size to 48" do
      text_block = subject.banner("hello!")
      text_block.font_size.should eql 48
    end

    it "should set title font size to 34" do
      text_block = subject.title("hello!")
      text_block.font_size.should eql 34
    end

    it "should set subtitle font size to 26" do
      text_block = subject.subtitle("hello!")
      text_block.font_size.should eql 26
    end

    it "should set tagline font size to 18" do
      text_block = subject.tagline("hello!")
      text_block.font_size.should eql 18
    end

    it "should set caption font size to 14" do
      text_block = subject.caption("hello!")
      text_block.font_size.should eql 14
    end

    it "should set para font size to 12" do
      text_block = subject.para("hello!")
      text_block.font_size.should eql 12
    end

    it "should set inscription font size to 10" do
      text_block = subject.inscription("hello!")
      text_block.font_size.should eql 10
    end
  end
end
