require 'swt_shoes/spec_helper'

describe Shoes::Swt::ImagePattern do
  let(:path) { File.join Shoes::DIR, 'static/shoes-icon.png'  }
  let(:dsl) { Shoes::ImagePattern.new(path) }

  subject { Shoes::Swt::ImagePattern.new(dsl) }

  it_behaves_like "an swt pattern"

   describe "#apply_as_fill" do
    let(:gc) { double("gc") }

    it "sets background" do
      gc.should_receive(:set_background_pattern)
      subject.apply_as_fill(gc, 10, 20, 100, 200)
    end
  end 
end
