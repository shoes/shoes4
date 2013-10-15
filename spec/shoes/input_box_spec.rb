require 'shoes/spec_helper'

describe Shoes::EditBox do
  let(:left) { 10 }
  let(:top) { 20 }
  let(:width) { 100 }
  let(:height) { 200 }

  let(:app) { Shoes::App.new }
  let(:parent) { Shoes::Flow.new(app, app) }
  let(:text) { "the text" }

  subject { Shoes::EditBox.new(app, parent, text, left: left, top: top, width: width, height: height) }

  it_behaves_like "object with dimensions"

  describe "relative dimensions from parent" do
    let(:relative_opts) { { left: left, top: top, width: relative_width, height: relative_height } }

    subject { Shoes::EditBox.new(app, parent, text, relative_opts) }

    it_behaves_like "object with relative dimensions"
  end
end
