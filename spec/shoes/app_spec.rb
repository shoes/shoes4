require 'shoes/spec_helper'

describe Shoes::App do
  let(:input_blk) { Proc.new {} }
  let(:opts) { Hash.new }
  subject(:app) { Shoes::App.new(opts, &input_blk) }

  it_behaves_like "DSL container"
  it { should respond_to :clipboard }
  it { should respond_to :clipboard= }
  it { should respond_to :owner }

  # For Shoes 3 compatibility
  it "exposes self as #app" do
    expect(app.app).to eq(app)
  end

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

      it 'has an absolute_left of 0' do
        subject.absolute_left.should eq 0
      end

      it 'has an absolute_top of 0' do
        subject.absolute_top.should eq 0
      end

      describe "internal app state" do
        let(:internal_app) { app.instance_variable_get(:@__app__) }

        it "sets title", :qt do
          internal_app.app_title.should == defaults[:title]
        end

        it "is resizable", :qt do
          internal_app.resizable.should be_true
        end
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

      describe "internal app state" do
        let(:internal_app) { app.instance_variable_get(:@__app__) }

        it "sets title", :qt do
          internal_app.app_title.should == opts[:title]
        end

        it "sets resizable", :qt do
          internal_app.resizable.should be_false
        end
      end

      it 'initializes a flow with the right parameters' do
        expect(Shoes::Flow).to receive(:new).with(anything, anything,
                                                  {width:  opts[:width],
                                                   height: opts[:height]}).
                                                  and_call_original
        subject
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

  describe "style" do
    let(:black) { Shoes::COLORS[:black] }
    let(:goldenrod) { Shoes::COLORS[:goldenrod] }
    let(:defaults) { {stroke: black, strokewidth: 1} }

    it "sets defaults" do
      expect(app.style).to eq(defaults)
    end

    it "merges new styles with existing styles" do
      new_styles = { strokewidth: 4 }
      app.style new_styles
      expect(app.style).to eq(defaults.merge(new_styles))
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
  end
  
  describe "connecting with gui" do 
    let(:gui) { app.instance_variable_get(:@__app__).gui }

    describe "clipboard" do
      it "gets clipboard" do
        expect(gui).to receive(:clipboard)
        subject.clipboard
      end

      it "sets clipboard" do
        expect(gui).to receive(:clipboard=).with("test")
        subject.clipboard = "test"
      end
    end

    describe "quitting" do
      it "#quit tells the GUI to quit" do
        expect(gui).to receive :quit
        subject.quit
      end

      it '#close tells the GUI to quit' do
        expect(gui).to receive :quit
        subject.close
      end
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
    describe 'starting' do
      let(:internal_app) { app.instance_variable_get(:@__app__) }

      context 'with defaults' do
        it 'does not start as fullscreen' do
          expect(internal_app.start_as_fullscreen?).to be_false
        end
      end

      describe 'with the fullscreen option' do
        let(:opts) { {fullscreen: true} }

        it 'starts as fullscreen ' do
          expect(internal_app.start_as_fullscreen?).to be_true
        end
      end
    end

    it 'is not in fullscreen by default' do
      expect(app).not_to be_fullscreen
    end

    it 'can be turned into fullscreen' do
      app.fullscreen = true
      expect(app).to be_fullscreen
    end

    describe 'going into fullscreen and back out again' do
      let(:defaults) { Shoes::InternalApp::DEFAULT_OPTIONS }

      before :each do
        app.fullscreen = true
        app.fullscreen = false
      end

      # Failing on Mac fullscreen doesnt seem to work see #397
      it 'is not in fullscreen', :fails_on_osx => true do
        expect(app).not_to be_fullscreen
      end

      # Failing on Mac fullscreen doesnt seem to work see #397
      it 'has its original width', :fails_on_osx => true do
        expect(app.width).to eq(defaults[:width])
      end

      # Failing on Mac fullscreen doesnt seem to work see #397
      it 'has its original height', :fails_on_osx => true do
        expect(app.height).to eq(defaults[:height])
      end
    end
  end

  describe '#add_child' do
    let(:internal_app) { app.instance_variable_get(:@__app__) }
    let(:child) {double 'child'}

    it 'adds the child to the top_slot when there is one' do
      top_slot_double = double 'top slot'
      internal_app.stub(top_slot: top_slot_double)
      expect(top_slot_double).to receive(:add_child).with(child)
      internal_app.add_child child
    end

    it 'adds the child to the own contents when there is no top_slot' do
      internal_app.stub top_slot: nil
      internal_app.add_child child
      internal_app.contents.should include child
    end
  end

  describe '#clear' do
    let(:input_blk) {Proc.new {para 'Hello'}}
    let(:internal_app) {subject.instance_variable_get(:@__app__)}

    it 'deletes everything (regression)' do
      subject.clear
      expect(internal_app.top_slot.contents).to be_empty
    end

    context 'clear in the initial input_block' do
      let(:input_blk) {
        Proc.new do
          para 'Hello there'
          clear do
            para 'see you'
          end
        end
      }

      it 'does not raise an error calling clear on a top_slot that is nil' do
        expect {subject}.not_to raise_error
      end
    end

  end

  describe 'DELEGATE_METHODS' do
    subject {Shoes::App::DELEGATE_METHODS}

    it {should_not include :new, :initialize}
    it {should include :para, :rect, :stack, :flow, :image, :location}
    it {should_not include :pop_style, :style_normalizer, :create}
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
