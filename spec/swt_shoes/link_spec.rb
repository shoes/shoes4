require 'swt_shoes/spec_helper'

describe Shoes::Swt::Link do
  include_context "swt app"
  let(:dsl) { Shoes::Link.new shoes_app, parent, ["linky"] }

  subject { Shoes::Swt::Link.new(dsl, swt_app) }

  its(:dsl) {is_expected.to eq dsl}

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
      allow(shoes_app).to receive(:add_listener)
      allow(shoes_app).to receive(:add_clickable_element)

      allow(swt_app).to receive(:clickable_elements) { [] }
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
      expect(swt_app).to receive(:remove_listener)

      subject.create_links_in([[layout, 0..10]])
      subject.remove

      expect(subject.link_segments).to be_empty
    end
  end
end
