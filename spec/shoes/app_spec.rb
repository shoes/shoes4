require 'shoes/spec_helper'

describe Shoes::App do
  let(:input_blk) { Proc.new {} }
  let(:opts) { Hash.new }
  subject(:app) { Shoes::App.new(opts, &input_blk) }

  after do
    Shoes.unregister_all
  end

  it_behaves_like "DSL container"
  it { is_expected.to respond_to :clipboard }
  it { is_expected.to respond_to :clipboard= }
  it { is_expected.to respond_to :owner }

  # For Shoes 3 compatibility
  it "exposes self as #app" do
    expect(app.app).to eq(app)
  end

  describe "initialize" do
    let(:input_blk) { Proc.new {} }

    it "initializes style hash", :qt do
      style = Shoes::App.new.style
      expect(style.class).to eq(Hash)
    end

    context "console" do
    end

    context "defaults" do
      let(:opts) { Hash.new }
      let(:defaults) { Shoes::InternalApp::DEFAULT_OPTIONS }

      it "sets width", :qt do
        expect(subject.width).to eq defaults[:width]
      end

      it "sets height", :qt do
        expect(subject.height).to eq defaults[:height]
      end

      it 'has an absolute_left of 0' do
        expect(subject.absolute_left).to eq 0
      end

      it 'has an absolute_top of 0' do
        expect(subject.absolute_top).to eq 0
      end

      describe "inspect" do
        include InspectHelpers

        it "shows title in #to_s" do
          expect(subject.to_s).to eq("(Shoes::App \"#{defaults.fetch :title}\")")
        end

        it "shows title in #inspect" do
          expect(subject.inspect).to match("(Shoes::App:#{shoes_object_id_pattern} \"#{defaults.fetch :title}\")")
        end
      end
    end

    context "from opts" do
      let(:opts) { {:width => 150, :height => 2, :title => "Shoes::App Spec", :resizable => false} }

      it "sets width", :qt do
        expect(subject.width).to eq opts[:width]
      end

      it "sets height", :qt do
        expect(subject.height).to eq opts[:height]
      end

      it "passes opts to InternalApp" do
        expect(Shoes::InternalApp).to receive(:new).with(kind_of(Shoes::App), opts).and_call_original
        subject
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
        expect(Shoes.apps.length).to eq(old_apps_length + 1)
        expect(Shoes.apps).to include(subject)
      end
    end
  end

  describe "style with defaults" do
    let(:default_styles) { Shoes::Common::Style::DEFAULT_STYLES }

    it "sets app defaults" do
      expect(app.style).to eq(default_styles)
    end

    it "merges new styles with existing styles" do
      subject.style strokewidth: 4
      expect(subject.style).to eq(default_styles.merge(strokewidth: 4))
    end

    default_styles = Shoes::Common::Style::DEFAULT_STYLES

    default_styles.each do |key, value|
      describe "#{key}" do
        it "defaults to #{value}" do
          expect(subject.style[key]).to eq(value)
        end

        it "passes default to objects" do
          expect(subject.line(0, 100, 100, 0).style[key]).to eq(value)
        end

      end
    end


    describe "default styles" do
      it "are independent among Shoes::App instances" do
        app1 = Shoes::App.new
        app2 = Shoes::App.new

        app1.strokewidth 10
        expect(app1.line(0, 100, 100, 0).style[:strokewidth]).to eq(10)

        # .. but does not affect app2
        expect(app2.line(0, 100, 100, 0).style[:strokewidth]).not_to eq(10)

      end
    end
  end

  describe "app-level style setter" do
    let(:goldenrod) { Shoes::COLORS[:goldenrod] }

    pattern_styles = Shoes::DSL::PATTERN_APP_STYLES
    other_styles = Shoes::DSL::OTHER_APP_STYLES

    pattern_styles.each do |style|
      it "sets #{style} for objects" do
        subject.public_send(style, goldenrod)
        expect(subject.line(0, 100, 100, 0).style[style]).to eq(goldenrod)
      end
    end

    other_styles.each do |style|
      it "sets #{style} for objects" do
        subject.public_send(style, 'val')
        expect(subject.line(0, 100, 100, 0).style[style]).to eq('val')
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
      expect(my_self).to eq app
    end
  end

  describe '#append' do
    let(:input_blk) {Proc.new do append do para 'Hi' end end}

    it 'understands append' do
      expect(subject).to respond_to :append
    end

    it 'should receive a call to what is called in the append block' do
      expect_any_instance_of(Shoes::App).to receive :para
      subject
    end
  end

  describe '#resize' do
    it 'understands resize' do
      expect(subject).to respond_to :resize
    end
  end

  describe 'fullscreen' do
    context 'defaults' do
      it 'is not fullscreen' do
        expect(app).not_to be_fullscreen
      end

      it 'can enter fullscreen' do
        app.fullscreen = true
        expect(app).to be_fullscreen
      end
    end

    describe 'going into fullscreen and back out again' do
      let(:defaults) { Shoes::InternalApp::DEFAULT_OPTIONS }

      before :each do
        app.fullscreen = true
        app.fullscreen = false
      end

      # Failing on Mac fullscreen doesnt seem to work see #397
      it 'is not in fullscreen', :fails_on_osx do
        expect(app).not_to be_fullscreen
      end

      # Failing on Mac fullscreen doesnt seem to work see #397
      it 'has its origina', :fails_on_osx do
        expect(app.width).to eq(defaults[:width])
      end

      # Failing on Mac fullscreen doesnt seem to work see #397
      it 'has its original height', :fails_on_osx do
        expect(app.height).to eq(defaults[:height])
      end
    end
  end

  describe '#clear' do
    let(:input_blk) do
      Proc.new do
        para 'Hello'
      end
    end
    let(:internal_app) {subject.instance_variable_get(:@__app__)}

    it 'has initial contents' do
      expect(subject.contents).to_not be_empty
    end

    it 'removes everything (regression)' do
      subject.clear
      expect(subject.contents).to be_empty
    end
  end

  describe "#gutter" do
    context "when app has a scrollbar" do
      let(:input_opts) { {width: 100, height: 100} }
      let(:input_block) { Proc.new { para "Round peg, square hole" * 200 } }

      it "has gutter of 16" do
        expect(app.gutter).to be_between(16, 17)
      end
    end

    context "when app has no scrollbar" do
      let(:input_block) { Proc.new { para "Round peg, square hole" } }

      it "has gutter of 16" do
        expect(app.gutter).to be_between(16, 17)
      end
    end
  end

  describe "#parent" do
    context "for a top-level element (not explicitly in a slot)" do
      it "returns the top_slot" do
        my_parent = nil
        app = Shoes.app do
          flow do
            my_parent = parent
          end
        end
        expect(my_parent).to eq app.instance_variable_get(:@__app__).top_slot
      end
    end

    context "for an element within a slot" do
      it "returns the enclosing slot" do
        my_parent = nil
        my_stack  = nil
        app = Shoes.app do
          my_stack = stack do
            flow do
              my_parent = parent
            end
          end
        end

        expect(my_parent).to eq my_stack
      end
    end

  end

  describe 'DELEGATE_METHODS' do
    subject {Shoes::App::DELEGATE_METHODS}

    describe 'does not include general ruby object methods' do
      it {is_expected.not_to include :new, :initialize}
    end

    describe 'it has access to Shoes app and DSL methods' do
      it {is_expected.to include :para, :rect, :stack, :flow, :image, :location}
    end

    describe 'it does not have access to private methods' do
      it {is_expected.not_to include :pop_style, :style_normalizer, :create}
    end

    describe 'there are blacklisted methods which it should not include' do
      it {is_expected.not_to include :parent}
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
    expect(Shoes.apps.length).to eq(0)
  end

  context "with no apps" do
    it { is_expected.to be_empty }
  end

  context "with one app" do
    let(:app) { double('app') }
    before :each do
      Shoes.register(app)
    end

    its(:length) { should eq(1) }
    it "marks first app as main app" do
      expect(Shoes.main_app).to be(app)
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
      expect(Shoes.main_app).to be(app_1)
    end
  end
end
