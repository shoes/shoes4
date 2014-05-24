require 'swt_shoes/spec_helper'

describe Shoes::Swt::Link do
  include_context "swt app"
  let(:dsl) { Shoes::Link.new shoes_app, parent, ["linky"] }

  subject { Shoes::Swt::Link.new(dsl, swt_app) }

  it "marks itself clickable" do
    expect(swt_app).to receive(:add_listener)
    expect(swt_app).to receive(:add_clickable_element)

    subject
  end

  its(:dsl) {should eq dsl}

  context "creating link segments" do
    let(:bounds)       { double("bounds", height: 0) }
    let(:inner_layout) { double("inner layout",
                                get_line_bounds: bounds, line_count: 1,
                                line_bounds: double(x: 0, y: 0, height: 0)) }
    let(:layout)       { double("layout",
                                get_location: double("position", x: 0, y: 0),
                                element_left: 0, element_top: 0,
                                layout: inner_layout) }

    before(:each) do
      shoes_app.stub(:add_listener)
      shoes_app.stub(:add_clickable_element)

      swt_app.stub(:clickable_elements) { [] }
    end

    it "clears existing" do
      subject.link_segments << double("segment")
      subject.create_links_in([])
      expect(subject.link_segments).to be_empty
    end

    it "adds new segments" do
      subject.create_links_in([
                                [layout, [5..10]],
                                [layout, [0..5]]
                              ])
      expect(subject.link_segments.count).to eql(2)
    end

    it "clears links" do
      # One remove call each for mouse down, mouse up
      expect(swt_app).to receive(:remove_listener).twice

      subject.create_links_in([[layout, 0..10]])
      subject.clear

      expect(subject.link_segments).to be_empty
    end
  end
end
