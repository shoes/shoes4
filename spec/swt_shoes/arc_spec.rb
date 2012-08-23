describe Shoes::Swt::Arc do
  let(:app_real) { double("app real") }
  let(:app) { double("app", real: app_real) }
  let(:left) { 100 }
  let(:top) { 200 }
  let(:width) { 300 }
  let(:height) { 400 }
  let(:angle1) { Shoes::PI }
  let(:angle2) { Shoes::HALF_PI }
  let(:opts) { { app: app, left: left, top: top, width: width, height: height, angle1: angle1, angle2: angle2} }
  let(:dsl) { double("dsl object", :angle1 => angle1, :angle2 => angle2) }
  let(:fill_color) { Shoes::Color.new(40, 50, 60, 70) }
  let(:stroke_color) { Shoes::Color.new(80, 90, 100, 110) }

  subject {
    Shoes::Swt::Arc.new(dsl, opts)
  }

  describe "#initialize" do
    before :each do
      app_real.should_receive(:add_paint_listener)
    end

    its(:left) { should eq(left) }
    its(:top) { should eq(top) }
    its(:width) { should eq(width) }
    its(:height) { should eq(height) }

    specify "fill delegates to dsl" do
      dsl.should_receive(:fill) { fill_color }
      subject.fill_alpha.should eq(70)
    end

    specify "stroke delegates to dsl" do
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
    include_context "paintable context"

    let(:shape) { double("shape") }
    #let(:shape) { Shoes::Swt::Arc.new(dsl, opts) }
    subject { Shoes::Swt::Arc::Painter.new(shape) }

    before :each do
      shape.should_receive(:fill)
      shape.should_receive(:fill_alpha)
      shape.should_receive(:stroke)
      shape.should_receive(:stroke_alpha)
      shape.should_receive(:strokewidth)
      shape.should_receive(:left).twice
      shape.should_receive(:top).twice
      shape.should_receive(:width).twice
      shape.should_receive(:height).twice
      shape.should_receive(:angle1).twice { angle1 }
      shape.should_receive(:angle2).twice { angle2 }
    end

    specify "fills shape" do
      gc.should_receive(:fill_arc)
      subject.paint_control(event)
    end

    specify "draws arc" do
      gc.should_receive(:draw_arc)
      subject.paint_control(event)
    end
  end

end
