require "swt_shoes/spec_helper"

describe Shoes::Swt::App do
  let(:opts) { {:background => Shoes::COLORS[:salmon]} }
  let(:app) { double('app', :opts => opts, :width => 0, :height => 0, :app_title => 'mock') }
  subject { Shoes::Swt::App.new(app) }

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
      the_display.should_receive(:app_name=).with('mock')
      subject
    end
  end

end
