require 'swt_shoes/spec_helper'

#require 'support/shared_examples_for_common_elements_spec'

describe SwtShoes::Button do

  #it_should_behave_like "A Common Element"


  class ButtonShoeLaces
    include SwtShoes::Button
    attr_accessor :gui_container, :gui_element, :text, :height, :width, :margin, :click_event_lambda
  end

  let(:stub_gui_parent) { Swt.display }
  let(:shoelace) {
    shoelace = ButtonShoeLaces.new
    debugger
    shoelace.parent_gui_container = stub_gui_parent
    shoelace
  }
end
