require 'swt_shoes/spec_helper'

describe Shoes::Swt::TextBlock do
  let(:real) { double('real', add_paint_listener: true, disposed?: false) }
  let(:gui) { double('gui', real: real) }
  let(:app) { double('app', gui: gui) }
  let(:opts) { {app: app, justify: true, leading: 10} }
  let(:dsl) { double('dsl', text: 'hello world', width: 200).as_null_object }
  let(:container) { app.gui.real }
  let(:gui_container_real) { container }

  subject {
    Shoes::Swt::TextBlock.new(dsl, opts)
  }

  context "#initialize" do
    it { should be_instance_of(Shoes::Swt::TextBlock) }
  end
  
  it_behaves_like "paintable"
  it_behaves_like "movable shape", 10, 20
  
  describe "text block painter" do
    let(:tl) { double("text layout").as_null_object }
    let(:event) { double("event", gc: gc) }
    let(:gc) { double("gc").as_null_object }
    subject { Shoes::Swt::TextBlock::TbPainter.new(dsl, opts) }
    
    before :each do
      ::Swt::TextLayout.stub(:new) { tl }
      ::Swt::Font.stub(:new) 
    end
    
    it "sets text" do
      tl.should_receive(:setText).with(dsl.text)
      subject.paintControl(event)
    end
    
    it "sets width" do
      tl.should_receive(:setWidth).with(dsl.width)
      subject.paintControl(event)
    end
    
    it "draws" do
      tl.should_receive(:draw).with(gc, dsl.left, dsl.top)
      subject.paintControl(event)
    end
    
    it "sets justify" do
      tl.should_receive(:setJustify).with(opts[:justify])
      subject.paintControl(event)
    end
    
    it "sets spacing" do
      tl.should_receive(:setSpacing).with(opts[:leading])
      subject.paintControl(event)
    end
    
    it "sets alignment" do
      tl.should_receive(:setAlignment).with(anything)
      subject.paintControl(event)
    end
    
    it "sets text styles" do
      tl.should_receive(:setStyle).with(anything, anything, anything).at_least(1).times
      subject.paintControl(event)
    end
  end
end
