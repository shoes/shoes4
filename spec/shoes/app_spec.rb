require 'shoes/spec_helper'

describe Shoes::App do
  let(:input_blk) { Proc.new {} }
  let(:opts) { Hash.new }
  let(:app) {Shoes::App.new(opts, &input_blk)}
  subject { app }

  it_behaves_like "DSL container"
  it { should respond_to :clipboard }
  it { should respond_to :clipboard= }
  it { should respond_to :owner }

  describe "initialize" do
    let(:input_blk) { Proc.new {} }

    before do
      Shoes::App.any_instance.stub(:flow)
    end

    it "initializes style hash", :qt do
      style = Shoes::App.new.style
      style.class.should eq(Hash)
    end

    context "console" do
    end

    context "defaults" do
      let(:opts) { Hash.new }
      let(:defaults) { Shoes::InternalApp::DEFAULT_OPTIONS }

      it "sets width", :qt do
        subject.width.should == defaults[:width]
      end

      it "sets height", :qt do
        subject.height.should == defaults[:height]
      end

      it "sets title", :qt do
        subject.app_title.should == defaults[:title]
      end

      it 'has an absolute_left of 0' do
        subject.absolute_left.should eq 0
      end

      it 'has an absolute_top of 0' do
        subject.absolute_top.should eq 0
      end

      it "is resizable", :qt do
        subject.resizable.should be_true
      end
    end

    context "from opts" do
      let(:opts) { {:width => 150, :height => 2, :title => "Shoes::App Spec", :resizable => false} }

      it "sets width", :qt do
        subject.width.should == opts[:width]
      end

      it "sets height", :qt do
        subject.height.should == opts[:height]
      end

      it "sets title", :qt do
        subject.app_title.should == opts[:title]
      end

      it "sets resizable", :qt do
        subject.resizable.should be_false
      end
    end

    context "when registering" do
      before :each do
        Shoes.unregister_all
      end

      it "registers" do
        old_apps_length = Shoes.apps.length
        subject
        Shoes.apps.length.should eq(old_apps_length + 1)
        Shoes.apps.include?(subject).should be_true
      end
    end
  end

  # This behavior is different from Red Shoes. Red Shoes doesn't expose
  # the style hash on Shoes::App.
  describe "style" do
    subject { Shoes::App.new }
    it_behaves_like "object with style"
  end

  describe "strokewidth" do
    it "defaults to 1" do
      subject.style[:strokewidth].should eq(1)
    end

    it "passes default to objects" do
      subject.line(0, 100, 100, 0).style[:strokewidth].should eq(1)
    end

    it "passes new values to objects" do
      subject.strokewidth 10
      subject.line(0, 100, 100, 0).style[:strokewidth].should eq(10)
    end
  end

  describe "stroke" do
    let(:black) { Shoes::COLORS[:black] }
    let(:goldenrod) { Shoes::COLORS[:goldenrod] }
    it "defaults to black" do
      subject.style[:stroke].should eq(black)
    end

    it "passes default to objects" do
      subject.oval(100, 100, 100).style[:stroke].should eq(black)
    end

    it "passes new value to objects" do
      subject.stroke goldenrod
      subject.oval(100, 100, 100).style[:stroke].should eq(goldenrod)
    end
  end

  describe "default styles" do
    it "is independent among Shoes::App instances" do
      app1 = Shoes::App.new
      app2 = Shoes::App.new

      app1.strokewidth 10
      app1.line(0, 100, 100, 0).style[:strokewidth].should == 10

      # .. but does not affect app2
      app2.line(0, 100, 100, 0).style[:strokewidth].should_not == 10
    end
  end

  describe "clipboard" do
    it "gets clipboard" do
      subject.gui.should_receive(:clipboard)
      subject.clipboard
    end

    it "sets clipboard" do
      subject.gui.should_receive(:clipboard=).with("test")
      subject.clipboard = "test"
    end
  end

  describe "quitting" do
    it "#quit tells the GUI to quit" do
      expect(subject.gui).to receive :quit
      subject.quit
    end

    it '#close tells the GUI to quit' do
      expect(subject.gui).to receive :quit
      subject.close
    end
  end

  describe "#started?" do
    it "checks the window has been displayed or not" do
      subject.started?
    end
  end

  describe 'Execution context' do
    it 'starts with self as the execution context' do
      my_self = nil
      app = Shoes.app do my_self = self end
      my_self.should eq app
    end
  end

  describe '#append' do
    let(:input_blk) {Proc.new do append do para 'Hi' end end}

    it 'understands append' do
      subject.should respond_to :append
    end

    it 'should receive a call to what is called in the append block' do
      Shoes::App.any_instance.should_receive :para
      subject
    end
  end

  describe 'fullscreen' do

    it 'does not starts as fullscreen by default' do
      subject.should_not be_start_as_fullscreen
    end

    describe 'with the fullscreen option' do
      let(:opts) {{fullscreen: true}}
      it 'starts as fullscreen ' do
        subject.should be_start_as_fullscreen
      end
    end

    it 'is not in fullscreen by default' do
      subject.should_not be_fullscreen
    end

    it 'can be turned into fullscreen' do
      subject.fullscreen = true
      subject.fullscreen.should be_true
    end

    describe 'going into fullscreen and back out again' do
      let(:defaults) { Shoes::InternalApp::DEFAULT_OPTIONS }

      before :each do
        subject.fullscreen = true
        subject.fullscreen = false
      end

      # Failing on Mac fullscreen doesnt seem to work see #397
      it 'is not in fullscreen', :fails_on_osx => true do
        subject.fullscreen.should be_false
      end

      # Failing on Mac fullscreen doesnt seem to work see #397
      it 'has its original width', :fails_on_osx => true do
        subject.width.should == defaults[:width]
      end

      # Failing on Mac fullscreen doesnt seem to work see #397
      it 'has its original height', :fails_on_osx => true do
        subject.height.should == defaults[:height]
      end
    end

  end

  describe 'add_child' do

    let(:child) {double 'child'}

    it 'adds the child to the top_slot when there is one' do
      top_slot_double = double 'top slot'
      top_slot_double.should_receive(:add_child).with child
      subject.stub top_slot: top_slot_double
      subject.add_child child
    end

    it 'adds the child to the own contents when there is no top_slot' do
      subject.stub top_slot: nil
      subject.add_child child
      subject.contents.should include child
    end
  end

end

describe "App registry" do
  subject { Shoes.apps }

  before :each do
    Shoes.unregister_all
  end

  it "only exposes a copy" do
    subject << double("app")
    Shoes.apps.length.should eq(0)
  end

  context "with no apps" do
    it { should be_empty }
  end

  context "with one app" do
    let(:app) { double('app') }
    before :each do
      Shoes.register(app)
    end

    its(:length) { should eq(1) }
    it "marks first app as main app" do
      Shoes.main_app.should be(app)
    end
  end

  context "with two apps" do
    let(:app_1) { double("app 1") }
    let(:app_2) { double("app 2") }

    before :each do
      [app_1, app_2].each { |a| Shoes.register(a) }
    end

    its(:length) { should eq(2) }
    it "marks first app as main app" do
      Shoes.main_app.should be(app_1)
    end
  end
end
