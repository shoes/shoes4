require 'shoes/spec_helper'

describe Shoes::Check do
  let(:left) { 10 }
  let(:top) { 20 }
  let(:width) { 100 }
  let(:height) { 200 }

  let(:parent) { Shoes::Flow.new(app, app) }
  let(:blue)  { Shoes::COLORS[:blue] }
  let(:app) { Shoes::App.new }
  let(:opts){ {left: left, top: top, width: width, height: height} }

  subject { Shoes::Check.new(app, parent, opts) }

  it_behaves_like "object with dimensions"

  describe "check takes relative dimensions from parent" do
    let(:relative_opts) { { left: left, top: top, width: relative_width, height: relative_height } }

    subject { Shoes::Check.new(app, parent, relative_opts) }

    it_behaves_like "object with relative dimensions"
  end
end
