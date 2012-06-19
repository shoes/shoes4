require 'shoes/spec_helper'
# To be removed when Sound is converted from module to class
require 'white_shoes'

describe Shoes::Sound do
  let(:parent) { double("parent") }
  let(:filepath) { "../../samples/sounds/61847__simon-rue__boink-v3.wav" }
  subject { Shoes::Sound.new(parent, filepath) }

  its(:filepath) { should eq(filepath) }
  its(:parent) { should be(parent) }

  it "delegates play to gui" do
    subject.gui.should_receive(:play)
    subject.play
  end
end
