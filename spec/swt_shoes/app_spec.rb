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
                     :set_image => true, :background_mode= => true) }

  let(:mock_composite) { mock(:swt_composite,
                     :setBackground => true,
                     :setSize => true, :setLayout => true,
                     :background_mode= => true) }

  before :each do
    ::Swt::Widgets::Shell.stub(:new) { mock_shell }
    ::Swt.stub(:event_loop)
    ::Swt::Widgets::Composite.stub(:new) { mock_composite }
  end

  describe Shoes::App do
    subject     { Shoes::App.new }
    let(:white) { Shoes::COLORS[:white] }
    let(:blue)  { Shoes::COLORS[:blue]  }

    context "Shoes::App ancestors" do
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
