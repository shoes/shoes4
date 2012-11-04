require 'swt_shoes/spec_helper'

describe "alert" do

  TEXT = 'some random text'

  let(:dsl) { double('dsl', :text => TEXT) }
  let(:parent) { double('parent') }

  subject { Shoes::Swt::Alert.new dsl, parent, TEXT }
  
  specify "pops up a window containing a short message." do
    ::Swt::Widgets::Shell.stub(:new)
    mock_message_box = mock(:mb, setMessage: true, open: true)
    ::Swt::Widgets::MessageBox.stub(:new) { mock_message_box }
  end
end
