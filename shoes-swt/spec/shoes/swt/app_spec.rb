require "shoes/swt/spec_helper"

describe Shoes::Swt::App do
  let(:opts) { {:background => Shoes::COLORS[:salmon], :resizable => true} }
  let(:app) { double('app', :opts => opts,
                            :width => width,
                            :height => 0,
                            :app_title => 'double') }
  let(:dsl) { app }

  let(:opts_unresizable) { {:background => Shoes::COLORS[:salmon],
                            :resizable => false} }
  let(:app_unresizable) { double('app', :opts => opts_unresizable,
                                        :width => 0,
                                        :height => 0,
                                        :app_title => 'double') }
  let(:width) {0}

  subject { Shoes::Swt::App.new(app) }

  it { is_expected.to respond_to :clipboard }
  it { is_expected.to respond_to :clipboard= }

  it_behaves_like "clickable backend" do
    let(:swt_app) { subject }
    let(:click_block_parameters) { click_block_coordinates }
    let(:click_listener) { double("listener", add_click_listener: nil, add_release_listener: nil) }

    before do
      allow(dsl).to receive(:pass_coordinates?) { true }
      allow(subject).to receive(:click_listener) { click_listener }
    end
  end

  before :each do
    Shoes::Swt.unregister_all
  end

  context "when registering" do
    it "registers" do
      old_apps_length = Shoes::Swt.apps.length
      subject
      expect(Shoes::Swt.apps.length).to eq(old_apps_length + 1)
      expect(Shoes::Swt.apps.include?(subject)).to be_truthy
    end
  end

  context "when running on a mac" do
    let(:the_display) { ::Swt::Widgets::Display }

    it "should set the menubar title" do
      expect(the_display).to receive(:app_name=).with('double')
      subject
    end
  end

  context "main window style" do
    BASE_BITMASK =  Swt::SWT::CLOSE   |
                    Swt::SWT::MIN     |
                    Swt::SWT::V_SCROLL

    it "should return a bitmask that represents being resizable" do
      expect(subject.send(:main_window_style)).to eq(BASE_BITMASK | Swt::SWT::RESIZE | Swt::SWT::MAX)
    end

    it "should return a bitmask that represents not being resizable" do
      not_resizable = Shoes::Swt::App.new app_unresizable
      expect(not_resizable.send(:main_window_style)).to eq(BASE_BITMASK)
    end
  end

  context "when attempting to copy text" do
    it "copies text to clipboard" do
      # In case of failure when running tmux, please see #398
      text = "test"
      subject.clipboard = text
      expect(subject.clipboard).to eq(text)
    end
  end

  # fully testing the behavior would require stubbing for all of the open logic
  # which at the time is overkill imo
  it {is_expected.to respond_to :started?}

  describe 'App dimensions' do
    let(:client_area) {double 'client_area', width: width, height: height}
    let(:vertical_bar) {double 'scroll bar', visible?: bar_visible}
    let(:shell) {double('shell', client_area: client_area,
                                 vertical_bar: vertical_bar)}
    let(:width) {50}
    let(:height) {80}
    let(:bar_visible) {false}

    before :each do
      allow(subject).to receive(:shell).and_return(shell)
    end

    shared_examples_for 'reports client area dimensions' do
      it 'always returns the client area width' do
        expect(subject.width).to eq width
      end

      it 'returns the client area height' do
        expect(subject.height).to eq height
      end
    end

    it_behaves_like 'reports client area dimensions'

    context 'with a scroll bar' do
      let(:bar_visible) {true}

      it_behaves_like 'reports client area dimensions'
    end
  end

end
