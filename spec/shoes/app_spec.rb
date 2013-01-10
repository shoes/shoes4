require 'shoes/spec_helper'

describe Shoes::App do
  let(:input_blk) { Proc.new {} }
  let(:opts) { Hash.new }
  subject { Shoes::App.new(opts, &input_blk) }

  it_behaves_like "dsl container"

  describe "initialize" do
    let(:input_blk) { Proc.new {} }
    let(:app) { Shoes::App.new args, &input_blk }

    before do
      Shoes::App.any_instance.stub(:flow)
    end

    it "initializes style hash", :qt do
      style = Shoes::App.new.style
      style.class.should eq(Hash)
    end

    context "defaults" do
      let(:args) { Hash.new }

      it "sets width", :qt do
        pending 'Need to modify Shoes::Mock::App'
        app.width.should == Shoes::App::DEFAULT_OPTIONS[:width]
      end

      it "sets height", :qt do
        pending 'Need to modify Shoes::Mock::App'
        app.height.should == Shoes::App::DEFAULT_OPTIONS[:height]
      end

      it "sets title", :qt do
        app.app_title.should == Shoes::App::DEFAULT_OPTIONS[:title]
      end

      it "is resizable", :qt do
        app.resizable.should be_true
      end
    end

    context "from opts" do
      let(:args) { {:width => 150, :height => 2, :title => "Shoes::App Spec", :resizable => false} }

      it "sets width", :qt do
	pending 'Need to modify Shoes::Mock::App'
        app.width.should == args[:width]
      end

      it "sets height", :qt do
        pending 'Need to modify Shoes::Mock::App'
        app.height.should == args[:height]
      end

      it "sets title", :qt do
        app.app_title.should == args[:title]
      end

      it "sets resizable", :qt do
        app.resizable.should be_false
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

  # This behavior is different from Red Shoes. Red Shoes doesn't expose
  # the style hash on Shoes::App.
  describe "style" do
    subject { Shoes::App.new }
    it_behaves_like "object with style"
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
    let(:black) { Shoes::COLORS[:black] }
    let(:goldenrod) { Shoes::COLORS[:goldenrod] }
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

  describe "#quit" do
    it "quits" do
      subject.quit
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
