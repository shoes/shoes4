require 'shoes/spec_helper'

describe Shoes::Sound do
  let(:gui_container) { double("gui container") }
  let(:filepath) { "../../sounds/61847__simon-rue__boink-v3.wav" }
  subject { Shoes::Sound.new(gui_container, filepath) }

  its(:filepath) { should eq(filepath) }
  its(:gui_container) { should be(gui_container) }
end
