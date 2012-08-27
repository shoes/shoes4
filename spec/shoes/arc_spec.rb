describe Shoes::Arc do
  context "basic" do
    let(:app_gui) { double("gui") }
    let(:app) { double("app", :gui => app_gui) }

    subject { Shoes::Arc.new(app, 13, 44, 200, 300, 0, Shoes::TWO_PI) }

    it_behaves_like "object with stroke"
    it_behaves_like "object with fill"

    it "is a Shoes::Arc" do
      subject.class.should be(Shoes::Arc)
    end

    its(:left) { should eq(13) }
    its(:top) { should eq(44) }
    its(:width) { should eq(200) }
    its(:height) { should eq(300) }
    its(:angle1) { should eq(0) }
    its(:angle2) { should eq(Shoes::TWO_PI) }

    it "passes required values to backend" do
      gui_opts = {:left => 13, :top => 44, :width => 200, :height => 300, :angle1 => 0, :angle2 => Shoes::TWO_PI}
      Shoes::Mock::Arc.should_receive(:new).with(subject, app_gui, gui_opts)
      subject
    end
  end
end
