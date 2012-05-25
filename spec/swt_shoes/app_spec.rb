require "spec_helper"
require "swt_shoes/spec_helper"

describe SwtShoes::App do

  let(:mock_shell) { mock(:swt_shell,
                     :setSize => true, :setText => true,
                     :addListener => true, :setLayout => true) }
  before :each do
    Swt::Widgets::Shell.stub(:new) { mock_shell }
    Swt.stub(:event_loop)
  end

  describe Shoes::App do
    subject { Shoes::App.new }

    context "shell" do
      it "receives open" do
        mock_shell.should_receive(:open)
        subject
      end
    end

    context "Shoes::App ancestors" do
      subject { Shoes::App.ancestors }
      it { should include(SwtShoes::ElementMethods) }
      it "uses SwtShoes::ElementMethods before Shoes::ElementMethods" do
        framework_index = subject.index(SwtShoes::ElementMethods)
        shoes_index = subject.index(Shoes::ElementMethods)
        framework_index.should be < shoes_index
      end
    end
  end
end
