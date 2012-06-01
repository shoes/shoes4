require 'swt_shoes/spec_helper'

#require 'support/shared_examples_for_common_elements_spec'

describe Shoes::Swt::Button do

  #it_should_behave_like "A Common Element"

  class ButtonShoeLaces
    attr_accessor :gui_container, :gui_element, :text, :height, :width, :margin, :click_event_lambda
    attr_accessor :app

    # because Shoes::Swt::Button#move calls super :(
    def move(left, top)
      # no-op
    end
  end

  let(:gui_container) { double("gui container", :get_layout => true) }
  let(:gui_element) { double("gui element") }
  let(:app_gui_container) { double("app gui container") }
  let(:app) { double("app", :gui_container => app_gui_container) }
  let(:shoelace) {
    shoelace = ButtonShoeLaces.new
    shoelace.extend described_class
    shoelace.gui_container = gui_container
    shoelace.gui_element = gui_element
    shoelace.app = app
    shoelace
  }

  subject { shoelace }

  it_behaves_like "movable object with disposable gui element"
end
