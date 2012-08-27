describe Shoes::Swt::Arc do
  let(:app) { double("app") }
  let(:left) { 100 }
  let(:top) { 200 }
  let(:width) { 300 }
  let(:height) { 400 }
  let(:angle1) { Shoes::PI }
  let(:angle2) { Shoes::HALF_PI }
  let(:opts) { {left: left, top: top, width: width, height: height, angle1: angle1, angle2: angle2} }
  let(:dsl) { double("dsl object", angle1: angle1, angle2: angle2) }
  let(:fill_color) { Shoes::Color.new(40, 50, 60, 70) }
  let(:stroke_color) { Shoes::Color.new(80, 90, 100, 110) }

  subject {
    Shoes::Swt::Arc.new(dsl, app, opts)
  }

  describe "basics" do
    before :each do
      app.should_receive(:add_paint_listener)
    end

    its(:left) { should eq(left) }
    its(:top) { should eq(top) }
    its(:width) { should eq(width) }
    its(:height) { should eq(height) }

    specify "fill alpha delegates to dsl" do
      dsl.should_receive(:fill) { fill_color }
      subject.fill_alpha.should eq(70)
    end

    specify "stroke alpha delegates to dsl" do
      dsl.should_receive(:stroke) { stroke_color }
      subject.stroke_alpha.should eq(110)
    end

    specify "converts angle1 to degrees" do
      subject.angle1.should eq(180.0)
    end

    specify "converts angle2 to degrees" do
      subject.angle2.should eq(90.0)
    end
  end

  it_behaves_like "paintable"

  describe "painter" do
    include_context "painter context"

    subject { Shoes::Swt::Arc::Painter.new(shape) }

    before :each do
      shape.stub(:angle1) { angle1 }
      shape.stub(:angle2) { angle2 }
    end

    it_behaves_like "stroke painter"
    it_behaves_like "fill painter"

    context "normal fill style" do
      specify "fills arc" do
        gc.should_receive(:fill_arc)
        subject.paint_control(event)
      end

      specify "draws arc" do
        gc.should_receive(:draw_arc)
        subject.paint_control(event)
      end

      # Swt wants the upper left corner of the rectangle containing the arc. Shoes
      # uses (left, top) as the *center* of the rectangle containing the arc. Also,
      # Swt measures the arc counterclockwise, while Shoes measures it clockwise.
      specify "translates DSL values for Swt" do
        args = [-50, 0, width, height, angle1, -angle2]
        gc.should_receive(:fill_arc).with(*args)
        gc.should_receive(:draw_arc).with(*args)
        subject.paint_control(gc)
      end
    end

    context "wedge" do
      before :each do
        shape.stub(:wedge) { true }
      end

      specify "fills arc" do
        gc.should_receive(:fill_arc)
        subject.paint_control(event)
      end

      specify "draws arc" do
        gc.should_receive(:draw_arc)
        subject.paint_control(event)
      end

      specify "translates DSL values for Swt" do
        args = [-50, 0, width, height, angle1, -angle2]
        gc.should_receive(:fill_arc).with(*args)
        gc.should_receive(:draw_arc).with(*args)
        subject.paint_control(gc)
      end
    end
  end
end
