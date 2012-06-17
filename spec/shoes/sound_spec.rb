require 'shoes/spec_helper'
# To be removed when Sound is converted from module to class
require 'white_shoes'

describe Shoes::Sound do
  let(:gui_container) { double("gui container") }
  let(:filepath) { "../../samples/sounds/61847__simon-rue__boink-v3.wav" }
  subject { Shoes::Sound.new(gui_container, filepath) }

  its(:filepath) { should eq(filepath) }
  its(:gui_container) { should be(gui_container) }
end
