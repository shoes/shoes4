require 'shoes/swt/spec_helper'

describe Shoes::Swt::Link do
  include_context "swt app"

  let(:dsl) { Shoes::Link.new shoes_app, ["linky"] }

  subject { Shoes::Swt::Link.new(dsl, swt_app) }

  its(:dsl) {is_expected.to eq dsl}

  it_behaves_like "clickable backend"

  context "creating link segments" do
    let(:bounds)       { double("bounds", height: 0) }
    let(:inner_layout) { double("inner layout",
                                get_line_bounds: bounds, line_count: 1,
                                line_bounds: double(x: 0, y: 0, height: 0)) }
    let(:layout)       { double("layout",
                                get_location: double("position", x: 0, y: 0),
                                element_left: 0, element_top: 0,
                                layout: inner_layout) }

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
      expect(swt_app.click_listener).to receive(:remove_listeners_for).with(subject)

      subject.create_links_in([[layout, 0..10]])
      subject.remove

      expect(subject.link_segments).to be_empty
    end
  end
end
