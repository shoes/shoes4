require "swt_shoes/spec_helper"

describe Shoes::Swt::App do

  let(:mock_shell) { mock(:swt_shell,
                     :setSize => true, :setText => true,
                     :addListener => true, :setLayout => true, 
                     :setBackground => true, :open => true) }

  before :each do
    ::Swt::Widgets::Shell.stub(:new) { mock_shell }
    ::Swt.stub(:event_loop)
  end

  describe Shoes::App do
    subject     { Shoes::App.new }
    let(:white) { Shoes::COLORS[:white] }
    let(:blue)  { Shoes::COLORS[:blue]  }

    context "shell" do
      it "receives open" do
        mock_shell.should_receive(:open)
        subject
      end

      it "receives setBackground" do
        mock_shell.should_receive :setBackground
        subject
      end
    end

    context "Shoes::App background" do
      it "allows users to set the background from a block" do
        input_blk = Proc.new { background blue }
        args = { }
        app = Shoes::App.new args, &input_blk
        app.background.should == blue
      end
    end

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
