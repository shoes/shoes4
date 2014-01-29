require 'swt_shoes/spec_helper'

describe "Basic Element Methods" do

  class DSLShoeLaces
    include Shoes::DSL

    def initialize(gui)
      @gui = gui
      @app = self
      @style = {}
    end

    def current_slot
      @current_slot ||= ::Shoes::Flow.new(app = Shoes::App.new, app)
    end

    attr_reader :gui, :app
  end

  # Doubles for a Shoes::Swt::App
  let(:app_gui) { double('app_gui', real: container, dsl: dsl) }
  let(:container) { double('container', disposed?: true) }
  let(:dsl) { double('dsl', rotate: 0 ) }

  # Doubles for a Shoes::App
  let(:app) { DSLShoeLaces.new app_gui }

  describe "arc" do
    it "creates a Shoes::Arc" do
      app_gui.should_receive(:add_paint_listener)
      expect(app.arc(1, 2, 101, 201, 11, 21)).to be_an_instance_of(Shoes::Arc)
    end
  end

  describe "rect" do
    it "creates a Shoes::Rect" do
      app_gui.should_receive(:add_paint_listener)
      expect(app.rect(10, 20, 10, 20, angle: 45)).to be_an_instance_of(Shoes::Rect)
    end
  end

  describe "line" do
    it "creates a Shoes::Line" do
      app_gui.should_receive(:add_paint_listener)
      expect(app.line(1, 2, 101, 201)).to be_an_instance_of(Shoes::Line)
    end
  end

  describe "oval" do
    it "creates a Shoes::Oval" do
      app_gui.should_receive(:add_paint_listener)
      expect(app.oval(30, 20, 100, 200)).to be_an_instance_of(Shoes::Oval)
    end
  end

  describe "star" do
    it "creates a Shoes::Star" do
      app_gui.should_receive(:add_paint_listener)
      expect(app.star(30, 20)).to be_an_instance_of(Shoes::Star)
    end
  end

  describe "shape" do
    subject {
      app.shape do
        move_to 100, 200
        line_to 300, 400
      end
    }

    it "create a Shoes::Shape" do
      app_gui.should_receive(:add_paint_listener)
      expect(subject).to be_an_instance_of(Shoes::Shape)
    end
  end

  describe 'background' do
    context "with an invalid color" do
      it 'raises an argument error' do
        expect{ app.background('#ffq') }.to raise_error('Bad hex color: #ffq')
      end
    end

    context 'with a valid color' do
      it 'creates a Shoes::Background' do
        app_gui.should_receive(:add_paint_listener)
        expect(app.background('#fff')).to be_an_instance_of(Shoes::Background)
      end
    end

    context 'with no valid image' do
      it 'ignores the background' do
        app_gui.should_receive(:add_paint_listener)
        expect{ app.background('fake-shoes.jpg') }.not_to raise_error
      end
    end

    context 'with a valid image' do
      it 'creates a Shoes::Background' do
        app_gui.should_receive(:add_paint_listener)
        expect(app.background('static/shoes-icon.png')).to be_an_instance_of(Shoes::Background)
      end
    end
  end
end
