require "swt_shoes/spec_helper"

describe Shoes::Swt::App do
  let(:opts) { {:background => Shoes::COLORS[:salmon], :resizable => true} }
  let(:app) { double('app', :opts => opts,
                            :width => width,
                            :height => 0,
                            :app_title => 'double') }

  let(:opts_unresizable) { {:background => Shoes::COLORS[:salmon],
                            :resizable => false} }
  let(:app_unresizable) { double('app', :opts => opts_unresizable,
                                        :width => 0,
                                        :height => 0,
                                        :app_title => 'double') }
  let(:width) {0}

  subject { Shoes::Swt::App.new(app) }

  it { should respond_to :clipboard }
  it { should respond_to :clipboard= }

  before :each do
    Shoes::Swt.unregister_all
  end

  context "when registering" do
    it "registers" do
      old_apps_length = Shoes::Swt.apps.length
      subject
      Shoes::Swt.apps.length.should eq(old_apps_length + 1)
      Shoes::Swt.apps.include?(subject).should be_true
    end
  end

  context "when running on a mac" do
    let(:the_display) { ::Swt::Widgets::Display }

    it "should set the menubar title" do
      the_display.should_receive(:app_name=).with('double')
      subject
    end
  end

  context "main window style" do
    BASE_BITMASK =  Swt::SWT::CLOSE   |
                    Swt::SWT::MIN     |
                    Swt::SWT::MAX     |
                    Swt::SWT::RESIZE  |
                    Swt::SWT::V_SCROLL

    it "should return a bitmask that represents being resizable" do
      subject.send(:main_window_style).should eq(BASE_BITMASK)
    end

    it "should return a bitmask that represents not being resizable" do
      resizable = Shoes::Swt::App.new app_unresizable
      resizable.send(:main_window_style).should eq(BASE_BITMASK & ~Swt::SWT::RESIZE )
    end
  end

  context "when attempting to copy text" do
    it "copies text to clipboard" do
      pending 'Seems to be broken with tmux please see/fix #398'
      text = "test"
      subject.clipboard = text
      subject.clipboard.should eq(text)
    end
  end

  # fully testing the behavior would require stubbing for all of the open logic
  # which at the time is overkill imo
  it {should respond_to :started?}

end
