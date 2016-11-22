require 'spec_helper'

describe Shoes::Swt::Arrow do
  include_context "swt app"

  let(:left) { 55 }
  let(:top) { 77 }
  let(:width) { 222 }
  let(:height) { 222 }
  let(:dsl) { ::Shoes::Arrow.new shoes_app, parent, left, top, width }

  subject { Shoes::Swt::Arrow.new dsl, swt_app }

  it_behaves_like "paintable"
  it_behaves_like "updating visibility"
  it_behaves_like 'clickable backend'

  it "clears the path" do
    expect(subject.painter).to receive(:clear_path)
    subject.update_position
  end

  it "disposes of the painter" do
    expect(subject.painter).to receive(:dispose)
    subject.dispose
  end
end
