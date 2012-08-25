require "swt_shoes/spec_helper"

describe Shoes::Swt::App do
  class MockPoint
    def x; 0 end
    def y; 0 end
  end

  let(:mock_shell) { mock(:swt_shell,
                     :setSize => true, :setText => true, :getSize => MockPoint.new,
                     :addListener => true, :setLayout => true,
                     :open => true, :pack => true,
                     :addControlListener => true,
                     :set_image => true, :background_mode= => true,
                     :setBackground => true) }

  let(:mock_real) { mock(:swt_real,
                     :setBackground => true,
                     :setSize => true, :setLayout => true,
                     :background_mode= => true) }

  let(:mock_dsl) { mock(:shoes_app,
                     :opts => Shoes::App.new.opts,
                     :app_title => "Test") }

  subject { Shoes::Swt::App.new(mock_dsl) }

  before :each do
    ::Swt::Widgets::Shell.stub(:new) { mock_shell }
    ::Swt.stub(:event_loop)
    ::Swt::Widgets::Composite.stub(:new) { mock_real }
  end

  describe "basic" do
    before :each do
      mock_dsl.should_receive(:width)
      mock_dsl.should_receive(:height)
    end

    it "adds paint listener" do
      painter = double("painter")
      mock_real.should_receive(:add_paint_listener).with(painter)
      subject.add_paint_listener painter
    end
  end

  describe Shoes::App do
    context "ancestors" do
      subject { Shoes::App.ancestors }

      it { should include(Shoes::Swt::ElementMethods) }

      it "uses Shoes::Swt::ElementMethods before Shoes::ElementMethods" do
        framework_index = subject.index(Shoes::Swt::ElementMethods)
        shoes_index = subject.index(Shoes::ElementMethods)
        framework_index.should be < shoes_index
      end
    end
  end
end
